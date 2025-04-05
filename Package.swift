// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "RatingControl",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "RatingControl", targets: ["RatingControl"]),
    ],
    targets: [
        .target(
            name: "RatingControl",
            resources: [.process("PrivacyInfo.xcprivacy")]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
