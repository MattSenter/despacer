import ServiceManagement
import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    /// The window's opening and minimum content size; read by the app delegate.
    static let minimumSize = NSSize(width: 720, height: 660)

    @ObservedObject var watcher: ClipboardWatcher
    @AppStorage(Keys.enabled) private var enabled = true
    @AppStorage(Keys.useHistory) private var useHistory = true
    @AppStorage(Keys.useWrapRules) private var useWrapRules = true
    @AppStorage(Keys.playSound) private var playSound = false
    @AppStorage(Keys.showInMenuBar) private var showInMenuBar = true
    /// Bumped whenever the terminal lists change, so the Terminals pane redraws.
    @State private var terminalsRevision = 0
    @State private var openAtLogin = SMAppService.mainApp.status == .enabled
    @State private var selection: Pane = .fixing
    @State private var pasteAccess = PasteAccess.current
    /// Two-second "Copied" confirmation on Copy Version Info.
    @State private var copiedVersion = false
    /// Cmd+Q only closes this window, so quitting needs its own button (the
    /// menu bar icon, which also has Quit, can be turned off).
    let onQuit: () -> Void

    init(watcher: ClipboardWatcher, initialPane: Pane = .fixing, onQuit: @escaping () -> Void) {
        self.watcher = watcher
        _selection = State(initialValue: initialPane)
        self.onQuit = onQuit
    }

    enum Pane: String, CaseIterable, Identifiable {
        case fixing = "Fixing"
        case terminals = "Terminals"
        case system = "System"
        case permissions = "Permissions"
        case privacy = "Privacy"
        case otherProjects = "Other Projects"
        case about = "About"
        var id: String { rawValue }
        var title: String {
            switch self {
            case .fixing: return String(localized: "Fixing", comment: "Settings sidebar tab and pane title: how copies are fixed.")
            case .terminals: return String(localized: "Terminals", comment: "Settings sidebar tab and pane title: which apps Despacer watches.")
            case .system: return String(localized: "System", comment: "Settings sidebar tab and pane title. Also the label of the system version row in About.")
            case .permissions: return String(localized: "Permissions", comment: "Settings sidebar tab and pane title.")
            case .privacy: return String(localized: "Privacy", comment: "Settings sidebar tab and pane title.")
            case .otherProjects: return String(localized: "Other Projects", comment: "Settings sidebar tab and pane title listing the developer's other apps.")
            case .about: return String(localized: "About", comment: "Settings sidebar tab and pane title.")
            }
        }
        var icon: String {
            switch self {
            case .fixing: return "arrow.triangle.merge"
            case .terminals: return "terminal"
            case .system: return "gearshape"
            case .permissions: return "lock.shield"
            case .privacy: return "hand.raised"
            case .otherProjects: return "square.grid.2x2"
            case .about: return "info.circle"
            }
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            sidebar
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    sectionTitle(selection.title)
                    pane
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .tint(Brand.accent)
        }
        .focusEffectDisabled()
        .frame(minWidth: Self.minimumSize.width, minHeight: Self.minimumSize.height)
        // A change made in System Settings shows the moment the user comes back.
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            pasteAccess = .current
            openAtLogin = SMAppService.mainApp.status == .enabled
            terminalsRevision += 1
        }
    }

    // MARK: Sidebar

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable().interpolation(.high)
                .frame(width: 120, height: 120)
                .frame(maxWidth: .infinity)
                .padding(.top, 4).padding(.bottom, 18)
                .accessibilityHidden(true)

            ForEach(Pane.allCases) { item in
                Button {
                    selection = item
                } label: {
                    HStack(spacing: 9) {
                        Image(systemName: item.icon).frame(width: 18)
                            .accessibilityHidden(true)
                        Text(item.title).font(.system(size: 13, weight: .medium))
                        Spacer()
                    }
                    .padding(.horizontal, 10).padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 7)
                            .fill(selection == item ? Brand.accent.opacity(0.14) : .clear)
                    )
                    .foregroundStyle(selection == item ? Brand.accent : .secondary)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selection == item ? .isSelected : [])
            }
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                BuiltByCredit(content: "settings")
                CopyrightLine()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 10)
        }
        .padding(12)
        // Wide enough for the copyright line on one line at 10pt.
        .frame(width: 206)
        .background(Brand.sidebarFill)
    }

    @ViewBuilder
    private var pane: some View {
        switch selection {
        case .fixing: fixingPane
        case .terminals: terminalsPane
        case .system: systemPane
        case .permissions: permissionsPane
        case .privacy: privacyPane
        case .otherProjects: OtherProjectsView()
        case .about: aboutPane
        }
    }

    // MARK: Fixing

    private var fixingPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Claude Code and Codex break long commands across lines in the terminal, so they stop working when you copy and paste them. Despacer puts them back together as you copy.")
                .font(.system(size: 13))
                .fixedSize(horizontal: false, vertical: true)
            settingRow(Text("Fix terminal copies")) { switchToggle($enabled) }

            card(Text("How copies are fixed")) {
                VStack(alignment: .leading, spacing: 6) {
                    settingRow(Text("Match session history")) { switchToggle($useHistory) }
                    caption("Finds the exact original in Claude Code and Codex session files on this computer, so the fix is never a guess.")
                    HStack(spacing: 14) {
                        historySource("Claude Code", path: "~/.claude/projects")
                        historySource("Codex", path: "~/.codex/sessions")
                    }
                    .padding(.top, 2)
                }
                .disabled(!enabled)
                Divider().padding(.vertical, 4)
                VStack(alignment: .leading, spacing: 6) {
                    settingRow(Text("Repair other wrapped text")) { switchToggle($useWrapRules) }
                    caption("Rejoins lines that were clearly broken at the terminal's width, the moment you copy. Real multi-line scripts are left as they are.")
                }
                .disabled(!enabled)
            }

            VStack(alignment: .leading, spacing: 6) {
                settingRow(Text("Play a sound")) { switchToggle($playSound) }
                caption("Plays a short sound when a fixed copy is ready to paste.")
            }

            recentFixesCard
        }
    }

    /// Whether an agent's session folder exists on this computer.
    private func historySource(_ name: String, path: String) -> some View {
        let found = FileManager.default.fileExists(atPath: (path as NSString).expandingTildeInPath)
        return HStack(spacing: 5) {
            Image(systemName: found ? "checkmark.circle.fill" : "circle.dashed")
                .foregroundStyle(found ? Brand.accent : .secondary)
                .accessibilityHidden(true)
            Text(verbatim: name).font(.system(size: 12, weight: .medium))
            Text(found ? String(localized: "found", comment: "Status after an app name, e.g. 'Claude Code found': its session history exists on this computer.")
                       : String(localized: "not found", comment: "Status after an app name, e.g. 'Codex not found': no session history on this computer."))
                .font(.system(size: 12)).foregroundStyle(.secondary)
        }
        .help(path)
    }

    private var recentFixesCard: some View {
        card(Text("Recent fixes")) {
            if watcher.recent.isEmpty {
                caption("Nothing fixed yet. Copy a long command from Claude Code or Codex in your terminal, and it shows up here.")
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(watcher.recent) { fix in
                        if fix.id != watcher.recent.first?.id { Divider() }
                        fixRow(fix)
                    }
                }
            }
            caption("Kept in memory only, and gone when Despacer quits.")
                .padding(.top, 2)
        }
    }

    private func fixRow(_ fix: Fix) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(verbatim: fix.after)
                .font(.system(size: 11.5, design: .monospaced))
                .lineLimit(3)
                .truncationMode(.middle)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 10) {
                Text(fixSummary(fix))
                    .font(.system(size: 11)).foregroundStyle(.secondary)
                Spacer()
                Button("Copy Original") { watcher.put(fix.before) }
                    .help("Puts the text back on the clipboard exactly as it was copied.")
                Button("Copy Fixed") { watcher.put(fix.after) }
            }
            .controlSize(.small)
        }
    }

    /// "Exact match · iTerm2 · 3:21 PM"
    private func fixSummary(_ fix: Fix) -> String {
        let how = fix.exact
            ? String(localized: "Exact match", comment: "Recent fixes: the copy was found word for word in session history.")
            : String(localized: "Wrap rules", comment: "Recent fixes: the copy was repaired by rejoining wrapped lines.")
        let time = fix.date.formatted(date: .omitted, time: .shortened)
        return "\(how) · \(fix.appName) · \(time)"
    }

    // MARK: Terminals

    private var terminalsPane: some View {
        // Read so the pane redraws when the lists change.
        let _ = terminalsRevision
        return VStack(alignment: .leading, spacing: 16) {
            Text("Despacer only fixes text you copy while one of these apps is in front. Everything else you copy is left alone.")
                .font(.system(size: 13))
                .fixedSize(horizontal: false, vertical: true)

            card(Text("Built in")) {
                VStack(alignment: .leading, spacing: 4) {
                    // Installed first, so the ones in use aren't buried.
                    ForEach(TerminalApps.known.sorted { TerminalApps.appURL($0.bundleID) != nil && TerminalApps.appURL($1.bundleID) == nil }) { terminal in
                        terminalRow(terminal.bundleID, name: terminal.name) {
                            Toggle(isOn: Binding(
                                get: { TerminalApps.isEnabled(terminal.bundleID) },
                                set: { TerminalApps.setEnabled(terminal.bundleID, $0); terminalsRevision += 1 }
                            )) { EmptyView() }
                            .toggleStyle(.checkbox)
                            .labelsHidden()
                            .accessibilityLabel(Text(verbatim: terminal.name))
                        }
                    }
                }
            }

            card(Text("Added by you")) {
                let custom = TerminalApps.custom
                if custom.isEmpty {
                    caption("Add any other app you copy commands from, like a code editor with a built-in terminal.")
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(custom, id: \.self) { id in
                            terminalRow(id, name: TerminalApps.displayName(id)) {
                                Button("Remove") {
                                    TerminalApps.remove(id)
                                    terminalsRevision += 1
                                }
                                .controlSize(.small)
                            }
                        }
                    }
                }
                Button("Add App…", action: addApp)
                    .padding(.top, 4)
            }
        }
    }

    private func terminalRow<Control: View>(_ bundleID: String, name: String, @ViewBuilder control: () -> Control) -> some View {
        let installed = TerminalApps.appURL(bundleID) != nil
        return HStack(spacing: 10) {
            Group {
                if let icon = TerminalApps.icon(bundleID) {
                    Image(nsImage: icon).resizable().interpolation(.high)
                } else {
                    Image(systemName: "app.dashed").resizable().foregroundStyle(.tertiary)
                }
            }
            .frame(width: 22, height: 22)
            .accessibilityHidden(true)
            Text(verbatim: name).font(.system(size: 13))
            if !installed {
                Text("Not installed").font(.system(size: 11)).foregroundStyle(.secondary)
            }
            Spacer()
            control()
        }
        .padding(.vertical, 2)
    }

    private func addApp() {
        let panel = NSOpenPanel()
        panel.title = String(localized: "Add an App", comment: "Title of the file dialog for choosing an app to watch.")
        panel.prompt = String(localized: "Add", comment: "Button in the file dialog that adds the chosen app.")
        panel.allowedContentTypes = [.application]
        panel.directoryURL = URL(fileURLWithPath: "/Applications")
        panel.allowsMultipleSelection = true
        guard panel.runModal() == .OK else { return }
        for url in panel.urls { TerminalApps.add(appAt: url) }
        terminalsRevision += 1
    }

    // MARK: System

    private var systemPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            settingRow(Text("Open at login")) {
                switchToggle($openAtLogin)
                    .onChange(of: openAtLogin) { _, on in setOpenAtLogin(on) }
            }
            VStack(alignment: .leading, spacing: 6) {
                settingRow(Text("Show in menu bar")) { switchToggle($showInMenuBar) }
                if !showInMenuBar {
                    caption("To get back to these settings, open Despacer from your Applications folder.")
                }
            }
            card(Text("Quit")) {
                HStack {
                    caption("Closing this window keeps Despacer running. While it's quit, copies aren't fixed.")
                    Spacer()
                    Button("Quit Despacer", action: onQuit)
                }
            }
        }
    }

    private func setOpenAtLogin(_ on: Bool) {
        let service = SMAppService.mainApp
        do {
            if on { try service.register() } else { try service.unregister() }
        } catch {
            NSSound.beep()
        }
        let actual = service.status == .enabled
        if actual != on { openAtLogin = actual }
    }

    // MARK: Permissions

    private var permissionsPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            card(Text("Paste from Other Apps")) {
                caption("Despacer reads what you copy so it can fix it. Newer versions of macOS let you decide which apps may do that.")
                disclosure(allowed: true, "Used only for text you copy while a terminal app is in front.")
                disclosure(allowed: false, "Never keeps, shares, or sends anything you copy.")
                pasteAccessStatus.padding(.top, 4)
            }
            card(Text("Session history")) {
                caption("Reading Claude Code and Codex session files in your home folder needs no permission. Turn off Match session history under Fixing to stop it.")
            }
        }
    }

    private func disclosure(allowed: Bool, _ text: LocalizedStringKey) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Image(systemName: allowed ? "checkmark" : "xmark")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(allowed ? Brand.accent : .secondary)
                .accessibilityHidden(true)
            Text(text).font(.system(size: 12))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private var pasteAccessStatus: some View {
        switch pasteAccess {
        case .allowed:
            statusLine(ok: true, "Despacer can read your copies")
        case .notAsked:
            statusLine(ok: true, "macOS may ask the first time Despacer reads a copy. Choose Allow.")
        case .asks:
            statusLine(ok: false, "macOS asks every time Despacer reads a copy. Set it to Allow in System Settings.")
        case .denied:
            statusLine(ok: false, "Despacer can't read your copies, so nothing gets fixed. Set it to Allow in System Settings.")
        case .notNeeded:
            statusLine(ok: true, "No permission needed on this version of macOS")
        }
    }

    private func statusLine(ok: Bool, _ text: LocalizedStringKey) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Image(systemName: ok ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(ok ? Brand.accent : .orange)
                .accessibilityHidden(true)
            Text(text).font(.system(size: 12, weight: .semibold))
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 8)
            if !ok {
                Button("Open System Settings…") {
                    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Pasteboard")!)
                }
                .buttonStyle(.link).font(.system(size: 11)).foregroundStyle(Brand.accent)
            }
            Button("Re-check") { pasteAccess = .current }
                .buttonStyle(.link).font(.system(size: 11)).foregroundStyle(Brand.accent)
        }
    }

    /// macOS 15.4 and later let the user decide whether an app may read the
    /// clipboard without a paste.
    enum PasteAccess {
        case allowed, notAsked, asks, denied, notNeeded

        static var current: PasteAccess {
            guard #available(macOS 15.4, *) else { return .notNeeded }
            switch NSPasteboard.general.accessBehavior {
            case .alwaysAllow: return .allowed
            case .ask: return .asks
            case .alwaysDeny: return .denied
            default: return .notAsked
            }
        }
    }

    // MARK: Privacy

    private var privacyPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Despacer works entirely on your computer. It looks at the clipboard only when you copy from a terminal app, and to find exact originals it reads Claude Code and Codex session files on this computer. Nothing is saved, and nothing leaves your computer. No account, and no analytics.")
                .font(.system(size: 13))
                .fixedSize(horizontal: false, vertical: true)
            card(Text("Network activity")) {
                caption("None. Despacer never connects to the internet on its own. The links in these settings open in your browser.")
            }
            card(Text("Recent fixes")) {
                caption("The last ten fixes are kept in memory so you can undo them, and are gone when Despacer quits.")
            }
            Button("Read the full privacy policy") {
                NSWorkspace.shared.open(Self.privacyPolicyURL)
            }
            .buttonStyle(.link)
            .font(.system(size: 12))
            .foregroundStyle(Brand.accent)
        }
    }

    /// PRIVACY.md in the language the app is showing. Every app localization has
    /// a translated PRIVACY.<lang>.md (scripts/check-localization.py checks).
    private static var privacyPolicyURL: URL {
        let language = Bundle.main.preferredLocalizations.first ?? "en"
        let file = language == "en" ? "PRIVACY.md" : "PRIVACY.\(language).md"
        return URL(string: "https://github.com/MattSenter/despacer/blob/main/\(file)")!
    }

    // MARK: About

    private var aboutPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable().interpolation(.high)
                    .frame(width: 64, height: 64)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(verbatim: "Despacer").font(.system(size: 22, weight: .heavy))
                        .accessibilityAddTraits(.isHeader)
                    Text("Copy long commands from Claude Code and Codex, and paste them in one piece.")
                        .font(.system(size: 12)).foregroundStyle(.secondary)
                }
            }
            versionCard
            card(Text("On the web")) {
                HStack(spacing: 10) {
                    webButton("Source Code", icon: "chevron.left.forwardslash.chevron.right",
                              url: "https://github.com/MattSenter/despacer")
                    webButton("Report an Issue", icon: "exclamationmark.bubble",
                              url: "https://github.com/MattSenter/despacer/issues")
                    Spacer()
                }
            }
            card(Text("About the developer")) {
                caption("Despacer is designed, built, and shipped by Matt Senter, an independent developer who makes every Senternet product end to end.")
                HStack(spacing: 12) {
                    Button("See Other Projects") { selection = .otherProjects }
                    BuiltByCredit(content: "about")
                    Spacer()
                }
            }
        }
    }

    /// What am I running: the half of a support request people never know where to find.
    private var versionCard: some View {
        card(Text("Version")) {
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 6) {
                GridRow {
                    Text(verbatim: "Despacer").foregroundStyle(.secondary)
                    Text(Self.versionString).textSelection(.enabled)
                }
                GridRow {
                    Text("System").foregroundStyle(.secondary)
                    Text(Self.systemString).textSelection(.enabled)
                }
            }
            .font(.system(size: 12).monospacedDigit())
            Button {
                // Always English: it is pasted into a support request.
                watcher.put("Despacer \(Self.versionNumber), \(Self.systemString)")
                copiedVersion = true
                Task { try? await Task.sleep(for: .seconds(2)); copiedVersion = false }
            } label: {
                Label(copiedVersion ? String(localized: "Copied") : String(localized: "Copy Version Info"),
                      systemImage: copiedVersion ? "checkmark" : "doc.on.doc")
            }
            .help("Copies the Despacer and system versions, handy for a support request.")
        }
    }

    private func webButton(_ title: LocalizedStringKey, icon: String, url: String) -> some View {
        Button {
            NSWorkspace.shared.open(URL(string: url)!)
        } label: {
            Label(title, systemImage: icon)
        }
        .accessibilityAddTraits(.isLink)
    }

    /// "1.0 (7)": the marketing version and build number.
    private static var versionNumber: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? "?"
        let build = info?["CFBundleVersion"] as? String ?? "?"
        return "\(version) (\(build))"
    }

    private static var versionString: String {
        String(localized: "Version \(versionNumber)", comment: "Version row in About. The argument is the version and build, e.g. 1.0 (7).")
    }

    /// "macOS 26.0 (25A123)": the system half of what a support reply needs.
    private static var systemString: String {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        let number = v.patchVersion == 0 ? "\(v.majorVersion).\(v.minorVersion)"
                                         : "\(v.majorVersion).\(v.minorVersion).\(v.patchVersion)"
        var size = 0
        sysctlbyname("kern.osversion", nil, &size, nil, 0)
        var buffer = [CChar](repeating: 0, count: max(size, 1))
        sysctlbyname("kern.osversion", &buffer, &size, nil, 0)
        let build = String(cString: buffer)
        return build.isEmpty ? "macOS \(number)" : "macOS \(number) (\(build))"
    }

    // MARK: Kit

    private func sectionTitle(_ text: String) -> some View {
        Text(text).font(.system(size: 17, weight: .bold))
            .accessibilityAddTraits(.isHeader)
    }

    /// A titled rounded panel: the unit every grouped setting lives in.
    private func card<Content: View>(_ title: Text, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            title.font(.system(size: 13, weight: .semibold))
                .accessibilityAddTraits(.isHeader)
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: Brand.corner).fill(Brand.cardFill))
    }

    /// Label in a fixed 180pt column, control right after, so controls line up across rows.
    private func settingRow<Control: View>(_ label: Text, @ViewBuilder control: () -> Control) -> some View {
        HStack(spacing: 14) {
            label.font(.system(size: 13))
                .frame(width: 180, alignment: .leading)
                .accessibilityHidden(true)
            control()
                .accessibilityLabel(label)
            Spacer(minLength: 0)
        }
    }

    /// The native switch comes from `.toggleStyle(.switch)` where the window is built.
    private func switchToggle(_ isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) { EmptyView() }.labelsHidden().tint(Brand.accent)
    }

    private func caption(_ text: LocalizedStringKey) -> some View {
        Text(text)
            .font(.system(size: 11.5))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}
