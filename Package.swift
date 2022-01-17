// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftPress",
  products: [
    .library(
      name: "SwiftPress",
      targets: ["SwiftPress"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-markdown.git", branch: "main"),
  ],
  targets: [
    .target(
      name: "SwiftPress",
      dependencies: []
    ),
    .testTarget(
      name: "SwiftPressTests",
      dependencies: ["SwiftPress"]
    ),
  ]
)
