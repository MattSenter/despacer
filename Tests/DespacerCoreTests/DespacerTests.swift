import XCTest
@testable import DespacerCore

final class DespacerTests: XCTestCase {
    func testReadmeCurlWrappedByClaudeCode() {
        let copied = """
          curl --fail --location --retry 3 --connect-timeout 10 --max-time 120
          --output premail-demo.zip
          "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately
          -long-filename-for-testing-terminal-line-wrapping.zip"
        """
        let expected = #"curl --fail --location --retry 3 --connect-timeout 10 --max-time 120 --output premail-demo.zip "https://example.com/downloads/premail/a-fictional-demo-with-a-deliberately-long-filename-for-testing-terminal-line-wrapping.zip""#
        XCTAssertEqual(Despacer.normalize(copied), expected)
    }

    func testShortMultiLineScriptIsLeftAlone() {
        let copied = "  cd ~/workspace/app\n  npm install\n  npm run build"
        XCTAssertEqual(Despacer.normalize(copied), "cd ~/workspace/app\nnpm install\nnpm run build")
    }

    func testBackslashContinuationIsKept() {
        let copied = "  docker run --rm -it -v \"$PWD\":/work -w /work node:20 \\\n  npm test --workspaces --if-present"
        XCTAssertEqual(Despacer.normalize(copied), "docker run --rm -it -v \"$PWD\":/work -w /work node:20 \\\nnpm test --workspaces --if-present")
    }

    func testSingleLineTrimsIndentAndPadding() {
        XCTAssertEqual(Despacer.normalize("  ls -la   \n"), "ls -la")
    }

    func testSelectionStartingAfterIndentKeepsRealNewlines() {
        // Indistinguishable from a mid-line selection that wrapped (the archive
        // case), so the heuristic leaves it alone; the transcript match resolves it.
        XCTAssertEqual(Despacer.normalize("cd ~/workspace/app\n  npm install --workspaces --include-workspace-root"),
                       "cd ~/workspace/app\nnpm install --workspaces --include-workspace-root")
    }

    func testSelectionStartingMidLineThatClearlyWrapped() {
        let copied = "run it yourself from the project root with `npx some-tool\n  --a-very-long-flag-name-that-could-not-fit=value --another-flag --and-one-more-flag`"
        XCTAssertEqual(Despacer.normalize(copied), "run it yourself from the project root with `npx some-tool --a-very-long-flag-name-that-could-not-fit=value --another-flag --and-one-more-flag`")
    }

    func testTranscriptMatchRecoversOriginalSpan() {
        let prose = "or you can run it yourself with `tar --create --gzip --file demo-archive.tar.gz --directory demo-files .`."
        let copied = TranscriptMatcher.squash("tar --create --gzip\n  --file demo-archive.tar.gz --directory demo-files .")
        XCTAssertEqual(TranscriptMatcher.match(needle: copied, in: prose), "tar --create --gzip --file demo-archive.tar.gz --directory demo-files .")
    }

    func testTranscriptMatchKeepsRealNewlines() {
        let script = "Run:\n```\ncd app\nnpm install\n```"
        XCTAssertEqual(TranscriptMatcher.match(needle: TranscriptMatcher.squash("  cd app  \n  npm install"), in: script), "cd app\nnpm install")
    }

    func testReadsCodexAssistantMessagesAndToolCalls() {
        let message = #"{"type":"response_item","payload":{"type":"message","role":"assistant","content":[{"type":"output_text","text":"run `make all`"}]}}"#
        let call = #"{"type":"response_item","payload":{"type":"function_call","name":"shell","arguments":"{\"command\":[\"bash\",\"-lc\",\"ls -la\"]}"}}"#
        let user = #"{"type":"response_item","payload":{"type":"message","role":"user","content":[{"type":"input_text","text":"hi"}]}}"#
        XCTAssertEqual(TranscriptMatcher.texts(inTranscriptLine: ArraySlice(message.utf8)), ["run `make all`"])
        XCTAssertEqual(TranscriptMatcher.texts(inTranscriptLine: ArraySlice(call.utf8)), ["bash", "-lc", "ls -la"])
        XCTAssertEqual(TranscriptMatcher.texts(inTranscriptLine: ArraySlice(user.utf8)), [])
    }

    func testCodexWrapOnLongestLineKeepsTheSpace() {
        // Recorded from Codex at 80 columns. The first line is the longest, but
        // "india" + "juliet" would have fit on one line, so it is a word break.
        let copied = "  echo \"despacer probe alpha bravo charlie delta echo foxtrot golf hotel india\n  juliet kilo lima mike november oscar papa quebec romeo sierra tango\""
        XCTAssertEqual(Despacer.normalize(copied), "echo \"despacer probe alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november oscar papa quebec romeo sierra tango\"")
    }

    func testRequireAgentIndentLeavesPlainTerminalOutputAlone() {
        let ls = "Applications  Desktop  Documents  Downloads  Library  Movies  Music  Pictures  Public\nworkspace"
        XCTAssertEqual(Despacer.normalize(ls, requireAgentIndent: true), ls)
        let agent = "  gcloud logging read\n  'logName=\"projects/demo-tools/logs/firebasehosting.googleapis.com%2Fwebrequests\" AND"
        XCTAssertEqual(Despacer.normalize(agent, requireAgentIndent: true),
                       "gcloud logging read 'logName=\"projects/demo-tools/logs/firebasehosting.googleapis.com%2Fwebrequests\" AND")
    }
}
