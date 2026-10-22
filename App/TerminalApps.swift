import AppKit

/// The apps whose copies Despacer fixes: the known terminals, minus any the user
/// switched off, plus any the user added.
enum TerminalApps {
    struct Known: Identifiable {
        let bundleID: String
        let name: String
        var id: String { bundleID }
    }

    /// Terminals that run Claude Code and Codex. All on by default.
    static let known: [Known] = [
        Known(bundleID: "com.apple.Terminal", name: "Terminal"),
        Known(bundleID: "com.googlecode.iterm2", name: "iTerm2"),
        Known(bundleID: "com.mitchellh.ghostty", name: "Ghostty"),
        Known(bundleID: "dev.warp.Warp-Stable", name: "Warp"),
        Known(bundleID: "net.kovidgoyal.kitty", name: "kitty"),
        Known(bundleID: "org.alacritty", name: "Alacritty"),
        Known(bundleID: "com.github.wez.wezterm", name: "WezTerm"),
        Known(bundleID: "co.zeit.hyper", name: "Hyper"),
        Known(bundleID: "org.tabby", name: "Tabby"),
        Known(bundleID: "com.raphaelamorim.rio", name: "Rio"),
    ]

    private static var defaults: UserDefaults { .standard }

    static var disabled: Set<String> {
        Set(defaults.stringArray(forKey: Keys.disabledTerminals) ?? [])
    }

    static var custom: [String] {
        defaults.stringArray(forKey: Keys.customTerminals) ?? []
    }

    /// Every bundle identifier whose copies get fixed right now.
    static var active: Set<String> {
        Set(known.map(\.bundleID)).subtracting(disabled).union(custom)
    }

    static func isEnabled(_ bundleID: String) -> Bool {
        !disabled.contains(bundleID)
    }

    static func setEnabled(_ bundleID: String, _ on: Bool) {
        var off = disabled
        if on { off.remove(bundleID) } else { off.insert(bundleID) }
        defaults.set(off.sorted(), forKey: Keys.disabledTerminals)
    }

    /// Adds the app at `url`. Returns false when it has no bundle identifier or is
    /// already covered.
    @discardableResult
    static func add(appAt url: URL) -> Bool {
        guard let id = Bundle(url: url)?.bundleIdentifier else { return false }
        if known.contains(where: { $0.bundleID == id }) {
            setEnabled(id, true)
            return true
        }
        guard !custom.contains(id) else { return false }
        defaults.set(custom + [id], forKey: Keys.customTerminals)
        return true
    }

    static func remove(_ bundleID: String) {
        defaults.set(custom.filter { $0 != bundleID }, forKey: Keys.customTerminals)
    }

    static func appURL(_ bundleID: String) -> URL? {
        NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID)
    }

    /// The app's name as Finder shows it, or the bundle identifier when it isn't installed.
    static func displayName(_ bundleID: String) -> String {
        if let known = known.first(where: { $0.bundleID == bundleID }) { return known.name }
        guard let url = appURL(bundleID) else { return bundleID }
        return FileManager.default.displayName(atPath: url.path).replacingOccurrences(of: ".app", with: "")
    }

    static func icon(_ bundleID: String) -> NSImage? {
        appURL(bundleID).map { NSWorkspace.shared.icon(forFile: $0.path) }
    }
}
