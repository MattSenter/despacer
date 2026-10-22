import AppKit

/// The magic paste brush and sparkle, tinted by macOS for
/// light, dark and highlighted menu bars. Explicit reps retain Retina detail.
func makeMenuBarIcon() -> NSImage {
    let image = NSImage(size: NSSize(width: 18, height: 18))
    for suffix in ["", "@2x"] {
        guard let url = Bundle.main.url(forResource: "MenuBarIcon\(suffix)", withExtension: "png"),
              let data = try? Data(contentsOf: url),
              let rep = NSBitmapImageRep(data: data) else {
            preconditionFailure("Missing bundled menu bar icon")
        }
        rep.size = NSSize(width: 18, height: 18)
        image.addRepresentation(rep)
    }
    image.isTemplate = true
    image.accessibilityDescription = "Despacer"
    return image
}
