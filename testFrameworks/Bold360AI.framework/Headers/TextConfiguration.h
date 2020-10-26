
// NanorepUI version number: v3.8.7. 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasicConfiguration : NSObject
/// Text Font.
@property (nonatomic, copy) UIFont * _Nullable font;
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
