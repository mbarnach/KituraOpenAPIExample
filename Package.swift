// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KituraOpenAPIExample",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/mbarnach/Kitura.git", .branch("OpenAPI")),
        .package(url: "https://github.com/mbarnach/Kitura-OpenAPI.git", .branch("SwaggerUI-3.25.0")),
        .package(url: "https://github.com/IBM-Swift/Kitura-CredentialsJWT.git", from: "1.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "KituraOpenAPIExample",
            dependencies: [
                "Kitura",
                "KituraOpenAPI",
                "CredentialsJWT",
            ]),
        .testTarget(
            name: "KituraOpenAPIExampleTests",
            dependencies: ["KituraOpenAPIExample"]),
    ]
)