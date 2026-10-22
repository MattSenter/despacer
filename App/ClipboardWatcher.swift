import AppKit
import Combine

/// One repaired copy, kept in memory for the Recent fixes list and Undo.
struct Fix: Identifiable {
    let id = UUID()
    let before: String
    let after: String
    /// Found word for word in an agent's session history, rather than repaired by the wrap rules.
    let exact: Bool
    let appName: String
    let date: Date
}

/// Watches the clipboard and repairs text copied from a terminal app.
///
/// macOS has no clipboard notification, so this checks the pasteboard's change
/// count every 50 ms, which costs next to nothing. On a copy from a terminal,
/// the wrap rules' fix goes on the clipboard at once, so it is ready to paste;
/// then the session history lookup runs in the background and replaces it with
/// the exact original if it finds one and nothing newer has been copied.
final class ClipboardWatcher: ObservableObject {
    /// Newest first, at most `recentLimit`. Never written to disk.
    @Published private(set) var recent: [Fix] = []
    static let recentLimit = 10

    private let pasteboard = NSPasteboard.general
    private var lastSeen: Int
    private var timer: Timer?
    private let lookups = DispatchQueue(label: "com.mattsenter.Despacer.lookup", qos: .userInitiated)
    /// Loaded up front: the first load takes about 100 ms, which would delay the first fix.
    private let readySound = NSSound(named: "Tink")
    private let defaults = UserDefaults.standard

    init() {
        lastSeen = pasteboard.changeCount
    }

    func start() {
        guard timer == nil else { return }
        let timer = Timer(timeInterval: 0.05, repeats: true) { [weak self] _ in self?.poll() }
        timer.tolerance = 0.01
        // .common keeps it firing while a menu is open.
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    /// Puts text on the clipboard without Despacer treating it as a new copy.
    func put(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        lastSeen = pasteboard.changeCount
    }

    /// Puts the last fix's original text back on the clipboard.
    func undoLastFix() {
        guard let last = recent.first else { return }
        put(last.before)
    }

    private func poll() {
        let count = pasteboard.changeCount
        guard count != lastSeen else { return }
        lastSeen = count
        guard defaults.bool(forKey: Keys.enabled, default: true),
              let front = NSWorkspace.shared.frontmostApplication,
              let bundleID = front.bundleIdentifier,
              TerminalApps.active.contains(bundleID),
              let copied = pasteboard.string(forType: .string) else { return }
        let appName = front.localizedName ?? bundleID

        let useWrapRules = defaults.bool(forKey: Keys.useWrapRules, default: true)
        let quick = useWrapRules ? Despacer.normalize(copied, requireAgentIndent: true) : copied
        if quick != copied {
            put(quick)
            chime()
        }
        let quickCount = pasteboard.changeCount

        guard defaults.bool(forKey: Keys.useHistory, default: true) else {
            if quick != copied { record(before: copied, after: quick, exact: false, appName: appName) }
            return
        }
        lookups.async { [weak self] in
            let exact = TranscriptMatcher.findOriginal(of: copied)?.text
            DispatchQueue.main.async {
                guard let self else { return }
                let final = exact ?? quick
                if final != quick {
                    // Something newer was copied meanwhile; leave it alone.
                    guard self.pasteboard.changeCount == quickCount else { return }
                    self.put(final)
                    if quick == copied { self.chime() }
                }
                if final != copied {
                    self.record(before: copied, after: final, exact: exact != nil, appName: appName)
                }
            }
        }
    }

    private func chime() {
        guard defaults.bool(forKey: Keys.playSound, default: false) else { return }
        readySound?.stop()
        readySound?.play()
    }

    private func record(before: String, after: String, exact: Bool, appName: String) {
        recent.insert(Fix(before: before, after: after, exact: exact, appName: appName, date: Date()), at: 0)
        if recent.count > Self.recentLimit { recent.removeLast() }
    }
}
