
// NanorepUI version number: v3.8.10 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "AutoCompleteConfiguration.h"
#import "QuickOptionConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadMoreTitleConfiguration : AutoCompleteConfiguration
@end

@interface ReadMoreViewConfiguration : BasicConfiguration

/// Title Configuration.
@property (nonatomic, strong) ReadMoreTitleConfiguration *title;

/// Channels Configuration.
@property (strong, nonatomic, readonly) QuickOptionConfiguration *channelsConfig;

@end

NS_ASSUME_NONNULL_END
