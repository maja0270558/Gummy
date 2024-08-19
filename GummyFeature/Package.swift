// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
    name: "GummyFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "PlaybackService", targets: ["PlaybackService"]),
        .library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.11.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.5"),
        .package(url: "https://github.com/spotify/ios-sdk", from: "2.1.6"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: ["PlaybackService", "OnboardingFeature", .tca]
        ),
        .target(
            name: "PlaybackService",
            dependencies: [.dependencies, .spotify]
        ),
        .target(
            name: "OnboardingFeature",
            dependencies: ["PlaybackService", .tca]
        ),
    ]
)

// MARK: - Test target

package.targets.append(contentsOf: [
    .testTarget(
        name: "OnboardingFeatureTests",
        dependencies: ["OnboardingFeature", .tca]
    ),

    .testTarget(
        name: "AppFeatureTests",
        dependencies: ["AppFeature", .tca]
    ),
])

extension Target.Dependency {
    static let tca = product(name: "ComposableArchitecture",
                             package: "swift-composable-architecture")

    static let dependencies = product(name: "Dependencies",
                                      package: "swift-dependencies")

    static let spotify = product(name: "SpotifyiOS",
                                 package: "ios-sdk")
}
