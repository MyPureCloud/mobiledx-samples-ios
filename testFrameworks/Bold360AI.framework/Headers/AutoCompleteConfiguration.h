
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutoCompleteConfiguration : NSObject
@property (nonatomic, copy) UIFont * _Nullable font;
@property (nonatomic, copy) UIColor * _Nullable backgroundColor;
@property (nonatomic, copy) UIColor * _Nullable textColor;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@end

NS_ASSUME_NONNULL_END
