
// NanorepUI version number: v3.8.7. 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "IncomingBotConfiguration.h"

NS_ASSUME_NONNULL_BEGIN


@interface MultipleSelectionConfiguration : IncomingBotConfiguration
/**
 To avoid breaking changes - a copy of titleConfig and persistentOptionConfig is made under MultipleSelectionConfiguration
 While there are already configured for IncomingBotConfiguration but should be moved to MultipleSelectionConfiguration
 */

/**
Title Configuration
*/
@property (strong, nonatomic) IncomingBotTitleConfiguration *titleConfiguration;

/**
Persistent Option Configuration
*/
@property (strong, nonatomic) PersistentOptionConfiguration *persistentOptionConfiguration;

@end


NS_ASSUME_NONNULL_END
