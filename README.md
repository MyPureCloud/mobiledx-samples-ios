![](https://github.com/genesys/mobiledx-samples-ios/blob/master/GenesysMessengerSample/1280x720-PR-Meta-Image.jpeg)

# Overview

This repository contains sample iOS application demonstrating the use of the GC Mobile Messenger SDK.

## Getting Started
To get started with these samples, clone this repository to your local machine:

```bash
git clone git@github.com:MyPureCloud/mobiledx-samples-ios.git
```

## Prerequisites
- iOS 15 and above
- Automatic Reference Counting (ARC) is required in your project.
- CocoaPods.

## Installation
- Navigate to the cloned repository
- Run ```bash pod install ``` in your terminal
- Open "GCMessengerSDKSample.xcworkspace" file with Xcode
- Wait for the project to build
- Run the application on your device or simulator

## Documentation
[Mobile Messenger SDK](https://developer.genesys.cloud/commdigital/digital/webmessaging/mobile-messaging/messenger-mobile-sdk/)
[Transport Mobile SDK](https://developer.genesys.cloud/commdigital/digital/webmessaging/mobile-messaging/messenger-transport-mobile-sdk/)

## Questions and Support

For help, troubleshooting, or to share feedback about the Mobile Messenger SDK, please post in the [Genesys Cloud Community Forum](https://community.genesys.com/communities/gc-developer-community?CommunityKey=a39cc4d6-857e-43cb-be7b-019581ab9f38).
It's the best place to get quick responses from Genesys experts and the developer community.

# License
This project is licensed under the MIT License - see the LICENSE file for details.

# Analytics
The app is implementing Firebase Crashlytics. In order to run the app you must remove the reference to GoogleService-Info.plist or replace it with your own plist file

## Authenticated messaging
The app integrates Okta authentication. To use this authentication service, you must configure okta.properties file with the necessary data to the path GCMessengerSDKSample/app. See an example in GCMessengerSDKSample/app/okta.properties.example
