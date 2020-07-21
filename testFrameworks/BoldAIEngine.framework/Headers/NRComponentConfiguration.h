
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - NRComponentConfiguration
/************************************************************/

@interface NRComponentConfiguration : NSObject
- (instancetype)initWithParams:(NSDictionary *)params;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, copy) NSDictionary *params;
@property (nonatomic, copy, readonly) NSString *inJson;
@end

NS_ASSUME_NONNULL_END
