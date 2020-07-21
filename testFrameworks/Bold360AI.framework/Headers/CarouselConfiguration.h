
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "ChatElementConfiguration.h"

/************************************************************/
// MARK: - CarouselButtonConfiguration
/************************************************************/

@interface CarouselButtonConfiguration : ChatElementConfiguration
@end

/************************************************************/
// MARK: - CarouselConfiguration
/************************************************************/

@interface CarouselConfiguration : ChatElementConfiguration
/**
 Carousel Button Configuration
 */
@property (strong, nonatomic, readonly) CarouselButtonConfiguration *button;
@end
