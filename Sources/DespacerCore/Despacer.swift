import Foundation

/// Rejoins text that a terminal UI (Claude Code's Ink renderer) hard-wrapped
/// at the terminal width, so copied commands paste as one runnable line.
public enum Despacer {
    /// Below this, an inferred width is more likely a short multi-line script
    /// than a real terminal, so we leave the text alone.
    public static let minimumPlausibleWidth = 40

    /// Claude Code and Codex indent everything they print by at least this much.
    public static let agentIndent = 2

    /// - Parameters:
    ///   - width: the wrap width, if known (e.g. the terminal's columns minus
    ///     Claude Code's indent). When nil, it is inferred from the longest line.
    ///   - requireAgentIndent: leave the text exactly as it is unless it carries
    ///     an AI agent's output indent or blockquote bars. Ordinary terminal output (`ls` columns, logs)
    ///     can look wrapped, so the clipboard watcher only repairs indented text.
    public static func normalize(_ text: String, width: Int? = nil, requireAgentIndent: Bool = false) -> String {
        var lines = text.components(separatedBy: "\n").map { trimTrailing($0) }
        while lines.first?.isEmpty == true { lines.removeFirst() }
        while lines.last?.isEmpty == true { lines.removeLast() }
        guard !lines.isEmpty else { return "" }

        // Claude Code indents its output; strip the shared indent. A first line
        // indented less than the rest means the selection began after the indent,
        // possibly mid-line. Its on-screen length is then unknown, so it is measured
        // as if the selection began at the indent, and only clear wraps are joined.
        let rest = lines.dropFirst().filter { !$0.isEmpty }.map(leadingSpaces)
        let partialFirstLine = !rest.isEmpty && leadingSpaces(lines[0]) < rest.min()!
        let indent = partialFirstLine ? rest.min()! : lines.filter { !$0.isEmpty }.map(leadingSpaces).min() ?? 0
        lines = lines.map { String($0.dropFirst(min(indent, leadingSpaces($0)))) }

        // Claude Code draws a markdown blockquote as a bar and a space before every
        // line, wrapped lines included. Strip the bars (one per nesting level) so the
        // quote rejoins like prose. A partial first line may have begun past its bar.
        func everyLineBarred() -> Bool {
            let barred = (partialFirstLine ? Array(lines.dropFirst()) : lines).filter { !$0.isEmpty }
            return !barred.isEmpty && barred.allSatisfy { $0.hasPrefix(quoteBar) }
        }
        var quoteDepth = 0
        while everyLineBarred() {
            lines = lines.map(stripQuoteBar)
            quoteDepth += 1
        }
        if requireAgentIndent && indent < agentIndent && quoteDepth == 0 { return text }
        let firstLineOffset = indent + quoteDepth * 2

        let measured = partialFirstLine ? Array(lines.dropFirst()) : lines
        let wrapWidth = width ?? measured.map(\.count).max() ?? 0
        guard lines.count > 1, wrapWidth >= minimumPlausibleWidth else {
            return lines.joined(separator: "\n")
        }

        var output = lines[0]
        for (index, (previous, next)) in zip(lines, lines.dropFirst()).enumerated() {
            let shownLength = previous.count + (index == 0 && partialFirstLine ? firstLineOffset : 0)
            switch joinKind(previous: previous, shownLength: shownLength, next: next, width: wrapWidth) {
            case .midToken: output += next
            case .wordWrap: output += " " + next
            case .newline: output += "\n" + next
            }
        }
        return output
    }

    enum Join { case midToken, wordWrap, newline }

    static func joinKind(previous: String, shownLength: Int, next: String, width: Int) -> Join {
        if previous.isEmpty || next.isEmpty || previous.hasSuffix("\\") { return .newline }
        let firstWord = next.prefix { !$0.isWhitespace }
        // Wrappers only split a token that is wider than a whole line; a shorter
        // one is moved down intact. So a full line ends mid-token only when the
        // token spanning the break could not have fit on one line.
        if shownLength >= width {
            let lastWord = previous.reversed().prefix { !$0.isWhitespace }
            return lastWord.count + firstWord.count > width ? .midToken : .wordWrap
        }
        // The wrapper moved the next word down because it would not fit.
        if shownLength + 1 + firstWord.count > width { return .wordWrap }
        return .newline
    }

    /// The bar Claude Code draws down the left edge of a blockquote (U+258E).
    public static let quoteBar = "\u{258E}"

    static func stripQuoteBar(_ line: String) -> String {
        guard line.hasPrefix(quoteBar) else { return line }
        let rest = line.dropFirst()
        return String(rest.first == " " ? rest.dropFirst() : rest)
    }

    static func leadingSpaces(_ s: String) -> Int { s.prefix { $0 == " " }.count }

    static func trimTrailing(_ s: String) -> String {
        var s = Substring(s)
        while let last = s.last, last.isWhitespace { s = s.dropLast() }
        return String(s)
    }
}
