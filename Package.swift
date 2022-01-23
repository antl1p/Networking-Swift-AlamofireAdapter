// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking-Swift-AlamofireAdapter",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "AlamofireAdapter",
            targets: ["AlamofireAdapter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/antl1p/Networking-Swift", branch: "main"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.5.0"),
    ],
    targets: [
        .target(
            name: "AlamofireAdapter",
            dependencies: ["Networking-Swift", "Alamofire"]),
        .testTarget(
            name: "AlamofireAdapterTests",
            dependencies: ["AlamofireAdapter"]),
    ]
)
