// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftPress",
  platforms: [
    .macOS(.v12),
    .iOS(.v15),
    .tvOS(.v15),
    .macCatalyst(.v15),
    .watchOS(.v8),
  ],
  products: [
    .library(
      name: "SwiftPress",
      targets: ["SwiftPress"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/christianselig/swift-markdown.git", branch: "custom-attributes"),
  ],
  targets: [
    .target(
      name: "SwiftPress",
      dependencies: [
        .product(name: "Markdown", package: "swift-markdown"),
      ]
    ),
    .testTarget(
      name: "SwiftPressTests",
      dependencies: ["SwiftPress"]
    ),
  ]
)
