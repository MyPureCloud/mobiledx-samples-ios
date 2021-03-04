# Upgrade from legacy SDK v2 to v3

This doc will explains how to move from v2 to v3 legacy SDK.

**[As a result of the fact that App Store does not accept app updates using UIWebView as of December 2020](https://developer.apple.com/news/?id=12232019b), apps using Legacy (live chat) SDK V2 need to upgrade to V3.**

# Upgrade instructions

1. Create a Podfile in your project as shown in:
https://github.com/bold360ai/bold360-mobile-samples-ios/blob/develop/LegacyCodeTest/Podfile
2. Open terminal and:
cd to your sample
3. Run cocoapods command:

```
pod update // to get latest version
```

4. Open the generated workspace file.
5. Inside your project 
Make sure you replace `BoldChatVisitorSDK` with `BoldEngineUI`.

>Example

```
// Before
#import <BoldChatVisitorSDK/BoldChatViewController.h>
// After
#import <BoldEngineUI/BoldChatViewController.h>
```
>[Sample](https://github.com/bold360ai/bold360-mobile-samples-ios/tree/develop/LegacyCodeTest)
