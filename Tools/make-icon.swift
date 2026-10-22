// Packages the approved magic paste brush artwork. Run from the repo root:
// swift Tools/make-icon.swift
import AppKit

func png(_ source: NSImage, pixels: Int, centered: Bool = false) -> Data {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    NSGraphicsContext.current?.imageInterpolation = .high
    var destination = NSRect(x: 0, y: 0, width: pixels, height: pixels)
    if centered, let data = source.tiffRepresentation,
       let bitmap = NSBitmapImageRep(data: data) {
        var minX = bitmap.pixelsWide, minY = bitmap.pixelsHigh, maxX = -1, maxY = -1
        for y in 0..<bitmap.pixelsHigh {
            for x in 0..<bitmap.pixelsWide where (bitmap.colorAt(x: x, y: y)?.alphaComponent ?? 0) > 0.5 {
                minX = min(minX, x); maxX = max(maxX, x)
                minY = min(minY, y); maxY = max(maxY, y)
            }
        }
        if maxX >= minX, maxY >= minY {
            // Fit the visible artwork into 16 of the tray's 18 points, leaving
            // one point per edge for antialiasing. Preserve the original shape.
            let visibleSide = Double(max(maxX - minX + 1, maxY - minY + 1))
            let scale = Double(pixels) * (16.0 / 18.0) / visibleSide
            destination.size = NSSize(width: Double(bitmap.pixelsWide) * scale,
                                      height: Double(bitmap.pixelsHigh) * scale)
            destination.origin.x = Double(pixels) / 2 - Double(minX + maxX + 1) / 2 * scale
            destination.origin.y = Double(pixels) / 2 - (Double(bitmap.pixelsHigh) - Double(minY + maxY + 1) / 2) * scale
        }
    }
    source.draw(in: destination,
        from: .zero, operation: .copy, fraction: 1)
    NSGraphicsContext.restoreGraphicsState()
    return rep.representation(using: .png, properties: [:])!
}
let app = NSImage(contentsOfFile: "Resources/IconSources/AppIcon.png")!
let tray = NSImage(contentsOfFile: "Resources/IconSources/TrayIcon.png")!
try png(app, pixels: 1024).write(to: URL(fileURLWithPath: "Resources/AppIcon-1024.png"))
try png(app, pixels: 256).write(to: URL(fileURLWithPath: "docs/images/icon.png"))
for scale in [1, 2] {
    let suffix = scale == 1 ? "" : "@2x"
    try png(tray, pixels: 18 * scale, centered: true).write(to: URL(fileURLWithPath: "Resources/MenuBarIcon\(suffix).png"))
}
// ICNS PNG chunks avoid iconutil's sandboxed image-conversion subprocess.
func bigEndian(_ value: Int) -> Data {
    var number = UInt32(value).bigEndian
    return withUnsafeBytes(of: &number) { Data($0) }
}
var chunks = Data()
for (kind, pixels) in [("icp4", 16), ("icp5", 32), ("icp6", 64), ("ic07", 128),
                       ("ic08", 256), ("ic09", 512), ("ic10", 1024),
                       ("ic11", 32), ("ic12", 64), ("ic13", 256), ("ic14", 512)] {
    let payload = png(app, pixels: pixels)
    chunks.append(Data(kind.utf8))
    chunks.append(bigEndian(payload.count + 8))
    chunks.append(payload)
}
var icns = Data("icns".utf8)
icns.append(bigEndian(chunks.count + 8))
icns.append(chunks)
try icns.write(to: URL(fileURLWithPath: "Resources/AppIcon.icns"))
print("Packaged app icon, documentation icon, and 1x/2x tray icons.")

// macOS 26 and later draw an app icon from an Icon Composer .icon in the asset
// catalog, filling the system's rounded square edge to edge. A legacy .icns
// whose art doesn't fill that shape gets shrunk onto a gray tile instead. So
// the .icon gets a full-bleed square: the artwork's navy square, cropped from
// its transparent margin, over the same top-to-bottom navy gradient so the
// rounded corners (which the system re-masks) have no transparent slivers.
// AppIcon.icns stays as the icon for macOS 14 and 15.
let side = 1024
let source = NSBitmapImageRep(data: try Data(contentsOf: URL(fileURLWithPath: "Resources/IconSources/AppIcon.png")))!
var box = (minX: source.pixelsWide, minY: source.pixelsHigh, maxX: 0, maxY: 0)
for y in 0..<source.pixelsHigh { for x in 0..<source.pixelsWide where (source.colorAt(x: x, y: y)?.alphaComponent ?? 0) > 0.5 {
    box = (min(box.minX, x), min(box.minY, y), max(box.maxX, x), max(box.maxY, y))
} }
// The artwork's navy shape, minus 3% on each side: that drops its soft bevel and
// any transparent edge. The shape is slightly wider than tall (962 x 932), so
// filling the square stretches it about 3% vertically, which doesn't show.
let inset = Int(Double(box.maxX - box.minX) * 0.03)
let crop = (x: box.minX + inset, y: box.minY + inset,
            width: box.maxX - box.minX + 1 - inset * 2, height: box.maxY - box.minY + 1 - inset * 2)
func sample(_ x: Int, _ y: Int) -> NSColor { source.colorAt(x: x, y: y)!.usingColorSpace(.sRGB)! }
let midX = crop.x + crop.width / 2
// Sampled inside the navy, for the corners the artwork leaves transparent.
let topColor = sample(midX, crop.y + 4), bottomColor = sample(midX, crop.y + crop.height - 5)
let layer = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: side, pixelsHigh: side,
    bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
    colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: layer)
NSGraphicsContext.current?.imageInterpolation = .high
NSGradient(starting: topColor, ending: bottomColor)!.draw(in: NSRect(x: 0, y: 0, width: side, height: side), angle: -90)
// colorAt's y runs top-down; NSImage drawing's from-rect runs bottom-up.
app.draw(in: NSRect(x: 0, y: 0, width: side, height: side),
    from: NSRect(x: CGFloat(crop.x), y: CGFloat(source.pixelsHigh - crop.y - crop.height), width: CGFloat(crop.width), height: CGFloat(crop.height)),
    operation: .sourceOver, fraction: 1)
NSGraphicsContext.restoreGraphicsState()
try FileManager.default.createDirectory(atPath: "Resources/AppIcon.icon/Assets", withIntermediateDirectories: true)
try layer.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "Resources/AppIcon.icon/Assets/Artwork.png"))
print("Wrote Resources/AppIcon.icon/Assets/Artwork.png (full bleed, from a \(crop.width)x\(crop.height) crop)")
