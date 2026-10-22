import DespacerCore
import Foundation

// Fixes text that an AI coding agent's terminal UI hard-wrapped, so a copied
// command pastes as one runnable line. The Despacer app does this automatically;
// this is the same fix as a filter.
//
// Usage: pbpaste | despacer [--width N] [--no-transcripts] [--explain] | pbcopy
let args = CommandLine.arguments
var width: Int?
if let i = args.firstIndex(of: "--width"), i + 1 < args.count { width = Int(args[i + 1]) }

let input = String(decoding: FileHandle.standardInput.readDataToEndOfFile(), as: UTF8.self)
var output = Despacer.normalize(input, width: width)
var method = "wrap rules"
if !args.contains("--no-transcripts"), let found = TranscriptMatcher.findOriginal(of: input) {
    output = found.text
    method = "exact match in \(found.source.path)"
}
if args.contains("--explain") {
    FileHandle.standardError.write(Data("despacer: \(method)\(output == input ? ", no change" : "")\n".utf8))
}
print(output, terminator: "")
