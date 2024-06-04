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
        .library(name: "GenesysCloudBot",
                 targets: ["GenesysCloudBotTarget"]),
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
                
        .binaryTarget(name: "GenesysCloudBotTarget",
                      url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloudBot/GenesysCloudBot_version_t1.5.0_commit_ddc5b1e32523dc63e132ebf4778063124162385a.zip",
                      checksum: "593f8f488313a545b88dbf899ea6dcd155a39b566658395730c3e3afaeb154bf"),
                
        .binaryTarget(name: "GenesysCloudMessengerTarget",
                      url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloudMessenger/GenesysCloudMessenger_version_t1.5.0_commit_c79b9819aece4531cecf42d56349518e31d3127c.zip",
                      checksum: "b7dc446c23abba61a3752acebbfab76acfa7c759837602fe0a5022196b53f4dd"),
        
        .binaryTarget(name: "GenesysCloudTarget",
                      url: "https://genesysdx.jfrog.io/artifactory/genesys-cloud-ios.prod/GenesysCloud/GenesysCloud_version_t1.5.0_commit_d23aa1dfa95626397809c3561ec99f819e6f5205.zip",
                      checksum: "0755dbfd2069559fda2ba66ae191499873cec1ad37f7f64a6c12759a4746ea71"),

    ]
)

