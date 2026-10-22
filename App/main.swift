// Despacer: repair commands copied from AI coding agents in the terminal.
//
// Claude Code and Codex wrap long lines themselves, writing real newlines and
// indents instead of letting the terminal wrap them, so a copied command breaks
// apart when pasted. Despacer watches the clipboard and, when a copy comes from
// a terminal app, puts the command back together (see ClipboardWatcher).

import AppKit
import ServiceManagement
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, NSMenuDelegate, NSMenuItemValidation {
    let watcher = ClipboardWatcher()

    private var statusItem: NSStatusItem!
    private var statusVisibilityObservation: NSKeyValueObservation?
    private var settingStatusVisibility = false
    private var enabledItem: NSMenuItem!
    private var soundItem: NSMenuItem!
    private var undoItem: NSMenuItem!
    private var menuBarItem: NSMenuItem!
    private var loginItem: NSMenuItem!

    /// Set only by the explicit Quit items. Every other quit collapses to the menu bar.
    private var isQuitting = false
    private var settingsOpen = false

    private let defaults = UserDefaults.standard

    private var enabled: Bool {
        get { defaults.bool(forKey: Keys.enabled, default: true) }
        set { defaults.set(newValue, forKey: Keys.enabled) }
    }

    private var playSound: Bool {
        get { defaults.bool(forKey: Keys.playSound, default: false) }
        set { defaults.set(newValue, forKey: Keys.playSound) }
    }

    private var showInMenuBar: Bool {
        get { defaults.bool(forKey: Keys.showInMenuBar, default: true) }
        set { defaults.set(newValue, forKey: Keys.showInMenuBar) }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        buildMainMenu()
        buildStatusMenu()
        // The settings window and the menu both write to UserDefaults.
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMenu), name: UserDefaults.didChangeNotification, object: nil)
        watcher.start()

        // Opened by hand (Finder, Spotlight, Launchpad): show settings. Opened at login: stay quiet.
        if !launchedAtLogin { showSettings() }
    }

    // Opening the app again while it runs, or clicking its Dock icon, shows settings.
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showSettings()
        return false
    }

    // A stray Cmd+Q (or Quit from the Dock or a script) collapses to the menu bar
    // instead of terminating. Only the Quit items, and logout, restart or shutdown,
    // actually quit.
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if isQuitting || systemIsEndingSession { return .terminateNow }
        collapseToTray()
        return .terminateCancel
    }

    /// Logout, restart and shutdown send a quit event with a reason attached.
    private var systemIsEndingSession: Bool {
        guard let event = NSAppleEventManager.shared().currentAppleEvent,
              event.eventID == kAEQuitApplication else { return false }
        return event.attributeDescriptor(forKeyword: kAEQuitReason) != nil
    }

    @objc private func quitApp() {
        isQuitting = true
        NSApp.terminate(nil)
    }

    private var launchedAtLogin: Bool {
        guard let event = NSAppleEventManager.shared().currentAppleEvent else { return false }
        return event.eventID == kAEOpenApplication
            && event.paramDescriptor(forKeyword: keyAEPropData)?.enumCodeValue == keyAELaunchedAsLogInItem
    }

    // MARK: Settings window

    private lazy var settingsWindow: NSWindow = {
        // `open Despacer.app --args -openPane Terminals` opens on that pane (docs screenshots).
        let pane = defaults.string(forKey: "openPane").flatMap(SettingsView.Pane.init) ?? .fixing
        let view = SettingsView(watcher: watcher, initialPane: pane, onQuit: { [weak self] in self?.quitApp() }).toggleStyle(.switch)
        let hosting = NSHostingController(rootView: view)
        // Sizing is left to the window, so it opens at the minimum and can grow.
        hosting.sizingOptions = []
        let w = NSWindow(contentViewController: hosting)
        w.title = String(localized: "Despacer Preferences", comment: "Settings window title.")
        w.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        w.setContentSize(SettingsView.minimumSize)
        w.contentMinSize = SettingsView.minimumSize
        w.titlebarAppearsTransparent = true
        w.backgroundColor = .windowBackgroundColor
        w.isReleasedWhenClosed = false
        w.delegate = self
        w.center()
        return w
    }()

    @objc private func showSettings() {
        settingsOpen = true
        updateActivationPolicy()
        settingsWindow.makeKeyAndOrderFront(nil)
        NSApp.activate()
    }

    /// A Dock icon only while the settings window is open.
    private func updateActivationPolicy() {
        let policy: NSApplication.ActivationPolicy = settingsOpen ? .regular : .accessory
        if NSApp.activationPolicy() != policy {
            NSApp.setActivationPolicy(policy)
        }
    }

    func windowWillClose(_ notification: Notification) {
        guard (notification.object as? NSWindow) === settingsWindow else { return }
        settingsOpen = false
        // Flip the policy on the next runloop tick; done synchronously while the
        // app is frontmost, the Dock ignores it and the icon lingers.
        DispatchQueue.main.async { self.updateActivationPolicy() }
    }

    /// Cmd+Q and Cmd+W: close settings and drop out of the Dock and Cmd+Tab,
    /// keeping only the menu bar icon.
    @objc private func collapseToTray() {
        if settingsOpen { settingsWindow.close() }
        NSApp.hide(nil)
    }

    @objc private func hideApp() {
        NSApp.hide(nil)
    }

    // MARK: Menus

    // Shown while Despacer is the active app (settings open).
    private func buildMainMenu() {
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: String(localized: "Preferences…", comment: "Menu item that opens the settings window (app menu and menu bar menu)."), action: #selector(showSettings), keyEquivalent: ",").target = self
        appMenu.addItem(.separator())
        // Cmd+H is an ordinary Hide; Cmd+W and Cmd+Q collapse to the menu bar.
        appMenu.addItem(withTitle: String(localized: "Hide Despacer", comment: "App menu item (Cmd+H)."), action: #selector(hideApp), keyEquivalent: "h").target = self
        appMenu.addItem(withTitle: String(localized: "Close Window", comment: "App menu item (Cmd+W)."), action: #selector(collapseToTray), keyEquivalent: "w").target = self
        appMenu.addItem(withTitle: String(localized: "Close and Keep Running", comment: "App menu item on Cmd+Q: closes the window but Despacer keeps running."), action: #selector(collapseToTray), keyEquivalent: "q").target = self
        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: String(localized: "Quit Despacer", comment: "Menu item that really quits the app."), action: #selector(quitApp), keyEquivalent: "").target = self
        let appItem = NSMenuItem()
        appItem.submenu = appMenu

        // Edit menu, so Cmd+C, Cmd+V and Cmd+A work in the settings window.
        let editMenu = NSMenu(title: String(localized: "Edit", comment: "Edit menu title."))
        editMenu.addItem(withTitle: String(localized: "Copy", comment: "Edit menu item."), action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: String(localized: "Paste", comment: "Edit menu item."), action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(withTitle: String(localized: "Select All", comment: "Edit menu item."), action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        let editItem = NSMenuItem()
        editItem.submenu = editMenu

        let main = NSMenu()
        main.addItem(appItem)
        main.addItem(editItem)
        NSApp.mainMenu = main
    }

    private func buildStatusMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = makeMenuBarIcon()

        let menu = NSMenu()
        menu.delegate = self
        enabledItem = menu.addItem(withTitle: String(localized: "Fix Terminal Copies", comment: "Menu bar menu checkbox that turns Despacer on or off."), action: #selector(toggleEnabled), keyEquivalent: "")
        enabledItem.target = self
        soundItem = menu.addItem(withTitle: String(localized: "Play Sound When Fixed", comment: "Menu bar menu checkbox: play a short sound when a fixed copy is ready to paste."), action: #selector(toggleSound), keyEquivalent: "")
        soundItem.target = self
        menu.addItem(.separator())
        undoItem = menu.addItem(withTitle: String(localized: "Undo Last Fix", comment: "Menu bar menu item: puts the last copy back on the clipboard exactly as it was copied."), action: #selector(undoLastFix), keyEquivalent: "")
        undoItem.target = self
        menu.addItem(.separator())
        menuBarItem = menu.addItem(withTitle: String(localized: "Show in Menu Bar", comment: "Menu bar menu checkbox that shows or hides the menu bar icon."), action: #selector(toggleMenuBar), keyEquivalent: "")
        menuBarItem.target = self
        loginItem = menu.addItem(withTitle: String(localized: "Open at Login", comment: "Menu bar menu checkbox that starts Despacer at login."), action: #selector(toggleLogin), keyEquivalent: "")
        loginItem.target = self
        menu.addItem(withTitle: String(localized: "Preferences…"), action: #selector(showSettings), keyEquivalent: ",").target = self
        menu.addItem(.separator())
        menu.addItem(withTitle: String(localized: "Quit Despacer"), action: #selector(quitApp), keyEquivalent: "q").target = self
        statusItem.menu = menu

        statusItem.isVisible = showInMenuBar
        // Cmd-dragging the icon out of the menu bar turns the setting off too.
        statusVisibilityObservation = statusItem.observe(\.isVisible) { [weak self] item, _ in
            guard let self, item.isVisible != self.showInMenuBar else { return }
            self.showInMenuBar = item.isVisible
        }
        refreshMenu()
    }

    // The menu enables items with a target on its own; Undo also needs a fix to undo.
    func validateMenuItem(_ item: NSMenuItem) -> Bool {
        item === undoItem ? !watcher.recent.isEmpty : true
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        refreshMenu()
    }

    @objc private func refreshMenu() {
        // Setting isVisible makes AppKit write its own defaults key, which posts
        // didChangeNotification and lands back here before isVisible reads the new
        // value. Without the guard that loops until the stack overflows.
        if !settingStatusVisibility && statusItem.isVisible != showInMenuBar {
            settingStatusVisibility = true
            statusItem.isVisible = showInMenuBar
            settingStatusVisibility = false
        }
        enabledItem.state = enabled ? .on : .off
        soundItem.state = playSound ? .on : .off
        menuBarItem.state = showInMenuBar ? .on : .off
        loginItem.state = SMAppService.mainApp.status == .enabled ? .on : .off
    }

    @objc private func toggleEnabled() { enabled.toggle() }
    @objc private func toggleSound() { playSound.toggle() }
    @objc private func toggleMenuBar() { showInMenuBar.toggle() }
    @objc private func undoLastFix() { watcher.undoLastFix() }

    @objc private func toggleLogin() {
        let service = SMAppService.mainApp
        do {
            if service.status == .enabled { try service.unregister() } else { try service.register() }
        } catch {
            NSSound.beep()
        }
        refreshMenu()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
