
// NanorepUI version number: v3.8.10 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>

@interface UIColor (BLDUtility)
/**
 Return representaiton in hex
 */
- (NSString *)bld_RepresentInHex;

/**
Return system background color
*/
+ (UIColor *)bld_SystemModeBackgroundColor;

/**
Return system text color
*/
+ (UIColor *)bld_SystemModeTextColor;
@end
