// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "QRScanner",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "QRScanner",
      targets: ["QRScanner"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "QRScanner",
      dependencies: [],
      resources: [.process("Resources")]),
    .testTarget(
      name: "QRScannerTests",
      dependencies: ["QRScanner"]),
  ])
