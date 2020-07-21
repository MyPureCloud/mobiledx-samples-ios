
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "AutoCompleteConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadMoreTitleConfiguration : AutoCompleteConfiguration

@end

@interface ReadMoreViewConfiguration : NSObject
@property (nonatomic, strong) ReadMoreTitleConfiguration *title;
@end

NS_ASSUME_NONNULL_END
