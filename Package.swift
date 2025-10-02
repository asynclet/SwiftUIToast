// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftUIToast",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftUIToast",
            targets: ["SwiftUIToast"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SwiftUIToast",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "SwiftUIToastTests",
            dependencies: ["SwiftUIToast"],
            path: "Tests"
        )
    ]
)
