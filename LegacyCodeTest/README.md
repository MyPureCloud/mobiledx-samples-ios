# Move from legacy SDK v2 to v3

This doc will explains how to move from v2 to v3 legacy SDK.

>Note: You should move to v3 since v2 contains UIWebView and
[App Store will no longer accept new apps using UIWebView as of April 2020 and app updates using UIWebView as of December 2020](https://developer.apple.com/news/?id=12232019b).

# How to move?

1. Create Podfile inside your project according to this one:
https://github.com/bold360ai/bold360-mobile-samples-ios/blob/develop/LegacyCodeTest/Podfile
2. Open terminal and:
cd to your sample
3. Use cocoapods command:
pod update // to get latest version
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
Sample: https://github.com/bold360ai/bold360-mobile-samples-ios/tree/develop/LegacyCodeTest
