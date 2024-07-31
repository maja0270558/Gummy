// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GummyFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "GummyFeature", targets: ["GummyFeature"]),

        .library(name: "PlaybackService", targets: ["PlaybackService"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture",
                 from: "1.11.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.5"),

        .package(url: "https://github.com/spotify/ios-sdk", from: "2.1.6"),
    ],
    targets: [
        .target(
            name: "GummyFeature",
            dependencies: ["PlaybackService", .tca]
        ),

        .target(
            name: "PlaybackService",
            dependencies: [.dependencies, .spotify]
        ),

        .testTarget(
            name: "GummyFeatureTests",
            dependencies: ["GummyFeature", .tca]
        ),
    ]
)

extension Target.Dependency {
    static let tca = product(name: "ComposableArchitecture",
                             package: "swift-composable-architecture")

    static let dependencies = product(name: "Dependencies",
                                      package: "swift-dependencies")

    static let spotify = product(name: "SpotifyiOS",
                                 package: "ios-sdk")
}
