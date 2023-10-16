// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "av-scanner",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "AVScanner", targets: ["AVScanner"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(name: "AVScanner"),
    ]
)
