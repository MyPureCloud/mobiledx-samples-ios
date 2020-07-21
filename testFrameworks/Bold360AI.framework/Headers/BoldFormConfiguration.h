
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoldFormElementConfiguration: NSObject
@property (nonatomic, copy) UIFont *font;
@property (nonatomic, copy) UIColor *textColor;
@property (nonatomic, copy) UIColor *backgroundColor;
@end

@interface BoldFormConfiguration : NSObject
@property (nonatomic, readonly) BoldFormElementConfiguration *titleConfig;
@property (nonatomic, readonly) BoldFormElementConfiguration *multiSelectElementConfig;
@end

NS_ASSUME_NONNULL_END
