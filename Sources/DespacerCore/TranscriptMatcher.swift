import Foundation

/// Finds the exact original text of a copied snippet in AI coding agents' session
/// transcripts, ignoring all whitespace: Claude Code (~/.claude/projects/**/*.jsonl)
/// and Codex (~/.codex/sessions/**/*.jsonl). A match is exact, so it needs no wrap
/// heuristics.
public enum TranscriptMatcher {
    /// Shorter snippets match too much unrelated text to be trusted.
    public static let minimumSignificantLength = 8

    public static var defaultRoots: [URL] {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return [home.appendingPathComponent(".claude/projects"), home.appendingPathComponent(".codex/sessions")]
    }

    /// Searches transcripts modified within `maxAge`, newest first, reading only
    /// the last `tailBytes` of each, since a copy almost always comes from recent
    /// output. Gives up after `budget` seconds.
    ///
    /// The same snippet can appear more than once, including already-broken copies
    /// pasted back into a session. Wrapping only adds line breaks, so the match with
    /// the fewest line breaks is the original.
    public static func findOriginal(
        of copied: String, roots: [URL] = defaultRoots, maxAge: TimeInterval = 86_400,
        tailBytes: Int = 8 << 20, budget: TimeInterval = 1
    ) -> (text: String, source: URL)? {
        let needle = squash(copied)
        guard needle.count >= minimumSignificantLength else { return nil }
        // Only JSON-decode transcript lines that contain every distinctive raw token.
        // Tokens with JSON-escaped characters would not appear verbatim, so they are skipped.
        let probes = Set(copied.split(whereSeparator: \.isWhitespace)
            .filter { $0.count >= 3 && !$0.contains("\"") && !$0.contains("\\") }
            .map { Array($0.utf8) })
            .sorted { $0.count > $1.count }
        guard let anchor = probes.first else { return nil }
        let deadline = Date().addingTimeInterval(budget)

        var best: (text: String, source: URL, breaks: Int)?
        for file in recentTranscripts(roots: roots, maxAge: maxAge) {
            guard Date() < deadline else { break }
            guard let bytes = tail(of: file, bytes: tailBytes) else { continue }
            for line in lines(in: bytes, containing: anchor).reversed()
            where probes.allSatisfy({ find($0, in: line, from: 0) != nil }) {
                for candidate in texts(inTranscriptLine: line) {
                    guard let original = match(needle: needle, in: candidate) else { continue }
                    let breaks = original.filter(\.isNewline).count
                    if breaks == 0 { return (original, file) }
                    if best == nil || breaks < best!.breaks { best = (original, file, breaks) }
                }
            }
        }
        return best.map { ($0.text, $0.source) }
    }

    static func tail(of file: URL, bytes: Int) -> [UInt8]? {
        guard let handle = try? FileHandle(forReadingFrom: file) else { return nil }
        defer { try? handle.close() }
        guard let size = try? handle.seekToEnd() else { return nil }
        try? handle.seek(toOffset: size > UInt64(bytes) ? size - UInt64(bytes) : 0)
        return (try? handle.readToEnd()).map { Array($0) }
    }

    /// Each newline-delimited line of `bytes` that contains `anchor`.
    static func lines(in bytes: [UInt8], containing anchor: [UInt8]) -> [ArraySlice<UInt8>] {
        var result: [ArraySlice<UInt8>] = []
        var from = 0
        while let hit = find(anchor, in: bytes[...], from: from) {
            let start = (bytes[..<hit].lastIndex(of: 0x0A) ?? -1) + 1
            let end = bytes[hit...].firstIndex(of: 0x0A) ?? bytes.count
            result.append(bytes[start..<end])
            from = end
        }
        return result
    }

    /// Offset of the first `needle` in `haystack` at or after `from`, via memmem.
    static func find(_ needle: [UInt8], in haystack: ArraySlice<UInt8>, from: Int) -> Int? {
        let base = haystack.startIndex
        let skip = max(0, from - base)
        guard skip < haystack.count else { return nil }
        return haystack.withUnsafeBytes { buffer -> Int? in
            needle.withUnsafeBytes { pattern -> Int? in
                guard let hit = memmem(buffer.baseAddress! + skip, buffer.count - skip, pattern.baseAddress!, pattern.count) else { return nil }
                return base + buffer.baseAddress!.distance(to: UnsafeRawPointer(hit))
            }
        }
    }

    /// Returns the span of `haystack` whose non-whitespace characters equal `needle`.
    /// Works on UTF-8 bytes so large candidates stay fast.
    public static func match(needle: String, in haystack: String) -> String? {
        let target = Array(squash(needle).utf8)
        let bytes = Array(haystack.utf8)
        var squashed: [UInt8] = []
        var origin: [Int] = []
        squashed.reserveCapacity(bytes.count)
        origin.reserveCapacity(bytes.count)
        for (offset, byte) in bytes.enumerated() where !isSpace(byte) {
            squashed.append(byte)
            origin.append(offset)
        }
        guard !target.isEmpty, let range = squashed.firstRange(of: target) else { return nil }
        return String(decoding: bytes[origin[range.lowerBound]...origin[range.upperBound - 1]], as: UTF8.self)
    }

    static func isSpace(_ byte: UInt8) -> Bool { byte == 0x20 || byte == 0x09 || byte == 0x0A || byte == 0x0D }

    static func squash(_ s: String) -> String { String(decoding: s.utf8.filter { !isSpace($0) }, as: UTF8.self) }

    static func recentTranscripts(roots: [URL], maxAge: TimeInterval) -> [URL] {
        let keys: [URLResourceKey] = [.contentModificationDateKey]
        let cutoff = Date().addingTimeInterval(-maxAge)
        return roots
            .compactMap { FileManager.default.enumerator(at: $0, includingPropertiesForKeys: keys) }
            .flatMap { $0.compactMap { $0 as? URL } }
            .filter { $0.pathExtension == "jsonl" }
            .compactMap { url -> (URL, Date)? in
                guard let date = try? url.resourceValues(forKeys: Set(keys)).contentModificationDate, date >= cutoff else { return nil }
                return (url, date)
            }
            .sorted { $0.1 > $1.1 }
            .map(\.0)
    }

    /// Assistant prose and tool-call inputs (e.g. shell commands) from one
    /// transcript line, in either Claude Code's or Codex's format.
    static func texts(inTranscriptLine line: ArraySlice<UInt8>) -> [String] {
        guard let object = try? JSONSerialization.jsonObject(with: Data(line)) as? [String: Any] else { return [] }

        // Claude Code: {"type":"assistant","message":{"content":[{"text"} | {"input":{...}}]}}
        if object["type"] as? String == "assistant",
           let message = object["message"] as? [String: Any],
           let blocks = message["content"] as? [[String: Any]] {
            return blocks.flatMap { block -> [String] in
                if let text = block["text"] as? String { return [text] }
                return block["input"].map(strings(in:)) ?? []
            }
        }

        // Codex: {"type":"response_item","payload":{"type":"message","role":"assistant",
        // "content":[{"text"}]}} or {"payload":{"type":"function_call","arguments":"<json>"}}
        if object["type"] as? String == "response_item", let payload = object["payload"] as? [String: Any] {
            if payload["role"] as? String == "assistant", let blocks = payload["content"] as? [[String: Any]] {
                return blocks.compactMap { $0["text"] as? String }
            }
            if let arguments = payload["arguments"] as? String {
                let decoded = try? JSONSerialization.jsonObject(with: Data(arguments.utf8))
                return decoded.map(strings(in:)) ?? [arguments]
            }
            if let input = payload["input"] { return strings(in: input) }
        }
        return []
    }

    /// Every string nested anywhere in a decoded JSON value.
    static func strings(in value: Any) -> [String] {
        switch value {
        case let string as String: return [string]
        case let array as [Any]: return array.flatMap(strings(in:))
        case let object as [String: Any]: return object.values.flatMap(strings(in:))
        default: return []
        }
    }
}
