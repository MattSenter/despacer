// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "despacer",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "despacer", targets: ["despacer"]),
        .library(name: "DespacerCore", targets: ["DespacerCore"]),
    ],
    targets: [
        .target(name: "DespacerCore"),
        .executableTarget(name: "despacer", dependencies: ["DespacerCore"]),
        .testTarget(name: "DespacerCoreTests", dependencies: ["DespacerCore"]),
    ]
)
