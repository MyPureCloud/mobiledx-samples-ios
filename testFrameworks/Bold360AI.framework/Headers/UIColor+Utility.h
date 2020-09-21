
// NanorepUI version number: v3.8.3 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>

@interface UIColor (Utility)
/**
 Return representaiton in hex
 */
- (NSString *)representInHex;

/**
Return system background color
*/
+ (UIColor *)systemModeBackgroundColor;

/**
Return system text color
*/
+ (UIColor *)systemModeTextColor;
@end
