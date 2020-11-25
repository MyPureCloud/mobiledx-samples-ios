
// NanorepUI version number: v3.8.10 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/************************************************************/
// MARK: - CustomFont
/************************************************************/

@interface CustomFont: NSObject
@property (nonatomic, copy) NSString *fontFileName;
@property (nonatomic, copy) UIFont *font;
@property (nonatomic, copy, readonly) NSString *fontWeight;
- (instancetype)initWithFont:(UIFont *)font;
- (instancetype)initWithFontFileName:(NSString *)fontFileName
                                font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
