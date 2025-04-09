![](https://github.com/genesys/mobiledx-samples-ios/blob/master/GenesysMessengerSample/1280x720-PR-Meta-Image.jpeg)

# Overview

This repository contains sample iOS application demonstrating the use of the GC Mobile Messenger SDK. 

## Getting Started
To get started with these samples, clone this repository to your local machine:

```bash
git clone git@github.com:MyPureCloud/mobiledx-samples-ios.git
```

## Prerequisites
- iOS 11 and above
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
[Transport Mobile SDK ](https://developer.genesys.cloud/commdigital/digital/webmessaging/mobile-messaging/messenger-transport-mobile-sdk/)
[Genesys Cloud Developer Forum](https://developer.genesys.cloud/forum/c/web-messaging/39)

# License
This project is licensed under the MIT License - see the LICENSE file for details.

# Analythics
The app is implementing Firebase Crashlytics. In order to run the app you must remove the reference to GoogleService-Info.plist or replace it with your own plist file

## Authenticated messaging
The app integrates Okta authentication. To use this authentication service, you must configure okta.properties file with the necessary data to the path GCMessengerSDKSample/app. See an example in GCMessengerSDKSample/app/okta.properties.example
