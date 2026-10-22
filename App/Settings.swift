import AppKit
import SwiftUI

/// UserDefaults keys shared by the settings window, the menu bar menu and the watcher.
enum Keys {
    static let enabled = "enabled"
    static let useHistory = "useHistory"
    static let useWrapRules = "useWrapRules"
    static let playSound = "playSound"
    static let showInMenuBar = "showInMenuBar"
    /// Built-in terminals the user switched off.
    static let disabledTerminals = "disabledTerminals"
    /// Bundle identifiers of apps the user added.
    static let customTerminals = "customTerminals"
}

extension UserDefaults {
    func bool(forKey key: String, default fallback: Bool) -> Bool {
        object(forKey: key) as? Bool ?? fallback
    }
}

/// Despacer's few colors. Everything else uses the system's own, so the window
/// follows Light and Dark with the rest of the Mac.
enum Brand {
    /// The icon's mint in Dark; a deeper teal in Light so text and links on the
    /// light canvas keep at least 4.5:1 contrast.
    static let accent = Color(nsColor: accentNS)
    static let accentNS = NSColor(name: nil) {
        $0.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
            ? NSColor(srgbRed: 0.31, green: 0.84, blue: 0.66, alpha: 1)
            : NSColor(srgbRed: 0.04, green: 0.43, blue: 0.34, alpha: 1)
    }
    static let cardFill = Color.primary.opacity(0.05)
    static let sidebarFill = Color.primary.opacity(0.035)
    static let corner: CGFloat = 10
}
