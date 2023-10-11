// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "GenesysCloud",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "MessengerTransport",
                 targets: ["MessengerTransportTarget"]),
        .library(name: "GenesysCloudCore",
                 targets: ["GenesysCloudCoreTarget"]),
        .library(name: "GenesysCloudAccessibility",
                 targets: ["GenesysCloudAccessibilityTarget"]),
        .library(name: "GenesysCloudBot",
                 targets: ["GenesysCloudBotTarget"]),
        .library(name: "GenesysCloudBold",
                 targets: ["GenesysCloudBoldTarget"]),
        .library(name: "GenesysCloudMessenger",
                 targets: ["GenesysCloudMessengerTarget"]),
        .library(name: "GenesysCloud",
                 targets: ["GenesysCloudTarget"])
    ],
    targets: [
        .binaryTarget(name: "MessengerTransportTarget",
                      url: "https://github.com/MyPureCloud/genesys-messenger-transport-mobile-sdk/releases/download/v2.4.1/MessengerTransport.xcframework.zip",
                      checksum: "948e6477c60dfd8a296bf5f251b69449c9fe56e01d7f4162211df2da75de0238"),
        
        .binaryTarget(name: "GenesysCloudCoreTarget",
                      url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloudCore/GenesysCloudCore_version_t1.5.0_commit_04c4ead1e64e480a6cbce313aeb2b415fb534914.zip",
                      checksum: "9cf504a8e8b55aba03dd1109b1d12526f5624578c3a2a4438973840010af4338"),
        
        .binaryTarget(name: "GenesysCloudAccessibilityTarget",
                      url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloudAccessibility/GenesysCloudAccessibility_version_t1.5.0_commit_ba9e3c97cab0798a5abaa633802953330cfaa4bc.zip",
                      checksum: "7509ce55e21f5fd584f6314e94475052f0acaefe849dfa8a8c43a5e994228872"),
        
        .binaryTarget(name: "GenesysCloudBotTarget",
                      url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloudBot/GenesysCloudBot_version_t1.5.0_commit_ddc5b1e32523dc63e132ebf4778063124162385a.zip",
                      checksum: "593f8f488313a545b88dbf899ea6dcd155a39b566658395730c3e3afaeb154bf"),
        
        .binaryTarget(name: "GenesysCloudBoldTarget",
                      url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloudBold/GenesysCloudBold_version_t1.5.0_commit_e7dcf89785b9ccd23dcbee70714c84a5ce0cbead.zip",
                      checksum: "e0d19a2b2d6af537f524da1ab6a34420e09bb5d3928cbb16be1a61cb1726684a"),
        
        .binaryTarget(name: "GenesysCloudMessengerTarget",
                      url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloudMessenger/GenesysCloudMessenger_version_t1.5.0_commit_c79b9819aece4531cecf42d56349518e31d3127c.zip",
                      checksum: "b7dc446c23abba61a3752acebbfab76acfa7c759837602fe0a5022196b53f4dd"),
        
        .binaryTarget(name: "GenesysCloudTarget",
                      url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloud/GenesysCloud_version_t1.5.0_commit_d23aa1dfa95626397809c3561ec99f819e6f5205.zip",
                      checksum: "0755dbfd2069559fda2ba66ae191499873cec1ad37f7f64a6c12759a4746ea71"),

    ]
)

