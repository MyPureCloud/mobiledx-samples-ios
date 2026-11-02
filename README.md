# Overview

This repository contains sample iOS application demonstrating the use of the Genesys Messenger Mobile SDK.

If you want to integrate the SDK in your own application please read the [Getting Started](https://developer.genesys.cloud/commdigital/digital/webmessaging/mobile-messaging/messenger-mobile-sdk/ios/) guide on the Genesys Cloud Developer Center.

## Getting Started
To get started with these samples, clone this repository to your local machine:

```bash
git clone git@github.com:MyPureCloud/mobiledx-samples-ios.git
```

## Prerequisites
- iOS 15 and above
- Xcode 26 and above
- CocoaPods

## Installation
- Navigate to the cloned repository
- Run ```pod install ``` in your terminal
- Open "GCMessengerSDKSample.xcworkspace" file with Xcode
- Build the project
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
