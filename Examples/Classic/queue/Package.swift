// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "queue",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "functions", targets: ["queue"]),
     ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SalehAlbuga/azure-functions-swift", from: "0.6.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "queue",
            dependencies: [.product(name: "AzureFunctions", package: "azure-functions-swift")])
    ]
)