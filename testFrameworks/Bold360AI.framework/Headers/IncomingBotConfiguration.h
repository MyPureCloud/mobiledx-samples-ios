
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "ChatElementConfiguration.h"
#import "QuickOptionConfiguration.h"
#import "PersistentOptionConfiguration.h"
#import "IncomingBotTitleConfiguration.h"
#import "CarouselConfiguration.h"
#import <BoldAIEngine/FeedbackConfiguration.h>

/************************************************************/
// MARK: - IncomingBotConfiguration
/************************************************************/

@interface IncomingBotConfiguration : ChatElementConfiguration
/**
Quick Option Configuration
*/
@property (strong, nonatomic, readonly) QuickOptionConfiguration *quickOptionConfig;

/**
Persistent Option Configuration
*/
@property (strong, nonatomic, readonly) PersistentOptionConfiguration *persistentOptionConfig;

/**
Instant Feedback Configuration
*/
@property (nonatomic, strong) InstantFeedbackConfiguration *instantFeedbackConfig;
        
/**
Title Configuration
*/
@property (strong, nonatomic, readonly) IncomingBotTitleConfiguration *titleConfig;

/**
 Carousel Configuration
 */
@property (strong, nonatomic, readonly) CarouselConfiguration *carouselConfig;
@end
