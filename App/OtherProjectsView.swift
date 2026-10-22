import AppKit
import SwiftUI

/// The rest of the Senternet lineup. Which products appear comes from
/// `senternet/registry/products.json` (every product with `appearsInPortfolio`),
/// with the developer tools first; names and summaries are verbatim from
/// mattsenter.com's `projects.data.ts` (as in CommandH), and each summary's
/// translations from that site's `projects/locales/` (Localization/*.lproj).
/// Senternet sites are linked at their `/from-despacer` lander (apps link to
/// landers); CommandH, which has no site, and external-owned BeeReady and
/// SeedMatrix at their root.
/// Refresh this list when the lineup changes.
struct OtherProjectsView: View {
    private struct Project: Identifiable {
        let name: String
        let summary: String
        let url: String
        let image: String   // base name in Resources/other-projects
        var id: String { name }
    }

    private static let projects: [Project] = [
        Project(name: "CommandH",
                summary: String(localized: "Cmd+H that works on the last app, so you can finally see your desktop."),
                url: "https://github.com/MattSenter/commandh", image: "commandh"),
        Project(name: "Weatherling",
                summary: String(localized: "Rain, snow, and autumn leaves on your Mac desktop. Weather effects, not a weather app."),
                url: "https://www.weatherling.app/from-despacer", image: "weatherling"),
        Project(name: "Burly",
                summary: String(localized: "Every link, in the right browser profile."),
                url: "https://www.burly.click/from-despacer", image: "burly"),
        Project(name: "Comoji",
                summary: String(localized: "Slack-style :emoji: autocomplete, everywhere on your Mac."),
                url: "https://www.comoji.io/from-despacer", image: "comoji"),
        Project(name: "Orgabot",
                summary: String(localized: "Orchestrate the work, not just the agents."),
                url: "https://www.orga.bot/from-despacer", image: "orgabot"),
        Project(name: "Premail",
                summary: String(localized: "Your inbox, defended."),
                url: "https://www.premail.pro/from-despacer", image: "premail"),
        Project(name: "Highwire",
                summary: String(localized: "See beyond the headlines."),
                url: "https://www.highwire.news/from-despacer", image: "highwire"),
        Project(name: "StockCar",
                summary: String(localized: "A podcast of your portfolio, not the market."),
                url: "https://www.stockcar.app/from-despacer", image: "stockcar"),
        Project(name: "Fix Siri",
                summary: String(localized: "Hey Siri, do better. A sourced record of Siri failures and Apple’s promises."),
                url: "https://www.fixsiri.com/from-despacer", image: "fixsiri"),
        // External-owned: always the root.
        Project(name: "BeeReady",
                summary: String(localized: "Lifesaving skills, one game at a time."),
                url: "https://www.beeready.buzz", image: "beeready"),
        Project(name: "SeedMatrix",
                summary: String(localized: "Every variety, every trial, one clear comparison."),
                url: "https://www.seedmatrix.com", image: "seedmatrix"),
    ]

    private let columns = [GridItem(.flexible(), spacing: 14),
                           GridItem(.flexible(), spacing: 14)]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("From the same workshop.")
                    .font(.system(size: 13, weight: .semibold))
                Text(Self.intro)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityOpenLinkAction("Matt Senter", url: Self.taggedURL(Self.introLinks[0].site))
                    .accessibilityOpenLinkAction("Senternet", url: Self.taggedURL(Self.introLinks[1].site))
            }

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(Self.projects) { card(for: $0) }
            }
            .padding(.top, 2)
        }
    }

    private static let introLinks = [(name: "Matt Senter", site: "https://www.mattsenter.com/from-despacer"),
                                     (name: "Senternet", site: "https://www.senter.net/from-despacer")]

    /// The intro with Matt Senter and Senternet linked to their landers.
    private static var intro: AttributedString {
        var text = AttributedString(String(localized: "Despacer is one of several products Matt Senter of Senternet designs, builds, and ships end to end. Here’s the rest of the lineup."))
        for (name, site) in introLinks {
            if let range = text.range(of: name), let url = taggedURL(site) {
                text[range].link = url
                text[range].foregroundColor = Brand.accent
                text[range].underlineStyle = .single
            }
        }
        return text
    }

    private func card(for project: Project) -> some View {
        Button {
            if let url = Self.taggedURL(project.url) { NSWorkspace.shared.open(url) }
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                shot(for: project)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .accessibilityHidden(true)
                HStack(spacing: 5) {
                    Text(project.name)
                        .font(.system(size: 14, weight: .semibold))
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Brand.accent)
                        .accessibilityHidden(true)
                }
                Text(project.summary)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: Brand.corner).fill(Brand.cardFill))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .pointingHandCursor()
        .accessibilityAddTraits(.isLink)
    }

    @ViewBuilder
    private func shot(for project: Project) -> some View {
        if let url = Bundle.main.url(forResource: project.image, withExtension: "webp", subdirectory: "other-projects"),
           let image = NSImage(contentsOf: url) {
            Image(nsImage: image)
                .resizable().interpolation(.high)
                .aspectRatio(16.0 / 10.0, contentMode: .fit)
        } else {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color.primary.opacity(0.08))
                .aspectRatio(16.0 / 10.0, contentMode: .fit)
        }
    }

    private static func taggedURL(_ urlString: String) -> URL? {
        OutboundLink.url(urlString, campaign: "other-projects", content: "app")
    }
}
