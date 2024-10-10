// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "GenesysCloud",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MessengerTransport",
                 targets: ["MessengerTransportTarget"]),
        .library(name: "GenesysCloudCore",
                 targets: ["GenesysCloudCoreTarget"]),
        .library(name: "GenesysCloudMessenger",
                 targets: ["GenesysCloudMessengerTarget"]),
        .library(name: "GenesysCloud",
                 targets: ["GenesysCloudTarget"])
    ],
    targets: [
        .binaryTarget(
            name: "MessengerTransportTarget",
            url: "https://genesysdx.jfrog.io/artifactory/TransportSDK/MessengerTransport.xcframework-2.7.2.zip",
            checksum: "970802b29b791a5e037d45cd4c6fc3aa7fda502a3081c2cadead141807ded9ea"
        ),
        .binaryTarget(
            name: "GenesysCloudCoreTarget",
            url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloudCore/GenesysCloudCore_version_t1.10.1_commit_c8013a2ce7dd0621b485e1c3254b4aa74db487c8.zip",
            checksum: "96a562b57e3f3174fc6cb879261c8525c5effd8b6027274df950b30819193a6e"
        ),
        .binaryTarget(
            name: "GenesysCloudMessengerTarget",
            url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloudMessenger/GenesysCloudMessenger_version_t1.10.1_commit_409f8efe780d21e16ed5aa9f142d7bd9565c4d65.zip",
            checksum: "0bd940be8cc8abcc9b9aa354b70cde676fe7d0a0155366522a5340a24c9c1b8f"
        ),
        .binaryTarget(
            name: "GenesysCloudTarget",
            url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloud/GenesysCloud_version_t1.10.1_commit_755e8ab3dc1e53022111d4218059d689966fb237.zip",
            checksum: "d9eaa21bece26207b303787b448ac0b2251cb43980f7775aa6dfdec033926663"
        ),
    ]
)

