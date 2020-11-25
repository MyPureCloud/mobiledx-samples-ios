
// NanorepUI version number: v3.8.10 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "CustomFont.h"

/************************************************************/
// MARK: - ChatViewConfiguration
/************************************************************/

@interface ChatViewConfiguration : NSObject

/**
 Chat View Background Color
 */
@property (copy, nonatomic) UIColor *backgroundColor;

/**
 Chat View Background Image
 */
@property (strong, nonatomic) UIImage *backgroundImage;

/**
 Chat Element Date Stamp Color
 */
@property (copy, nonatomic) UIColor *dateStampColor;

/**
 Chat Element Date Stamp Font
 */
@property (copy, nonatomic) UIFont *dateStampFont;

/**
 Chat Custom Font.
 */
@property (copy, nonatomic) CustomFont *customFont;

/**
Chat Element Max Length.
*/
@property (assign, nonatomic) NSInteger maxLength;

@end
