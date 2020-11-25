
// NanorepUI version number: v3.8.10 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomFont.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasicConfiguration : NSObject
/// Text Font.
@property (strong, nonatomic) CustomFont *customFont;

/// View Background Color.
@property (nonatomic, copy) UIColor * _Nullable backgroundColor;
/// Text Color.
@property (nonatomic, copy) UIColor * _Nullable textColor;
@end

@interface TextConfiguration : BasicConfiguration
/// Place Holder Text.
@property (nonatomic, copy) NSString *text;
@end

NS_ASSUME_NONNULL_END
