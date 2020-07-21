
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "IncomingBotConfiguration.h"
#import "IncomingLiveConfiguration.h"
#import "OutgoingConfiguration.h"
#import "SystemMessageConfiguration.h"
#import "InfoViewConfiguration.h"
#import "SearchViewConfiguration.h"
#import "ReadMoreViewConfiguration.h"
#import "ChatBarConfiguration.h"
#import "BoldFormConfiguration.h"
#import <BoldAIAccessibility/VoiceToVoiceConfiguration.h>

/************************************************************/
// MARK: - ChatConfiguration
/************************************************************/

@interface ChatConfiguration : NSObject

/**
 Chat View Configuration
 */
@property(strong, nonatomic, readonly) ChatViewConfiguration *chatViewConfig;

/**
 Incoming Bot Configuration
 */
@property(strong, nonatomic) IncomingBotConfiguration *incomingBotConfig;

/**
 Incoming Live Configuration
 */
@property(strong, nonatomic, readonly) IncomingLiveConfiguration *incomingLiveConfig;

/**
 Outgoing Configuration
 */
@property(strong, nonatomic, readonly) OutgoingConfiguration *outgoingConfig;

/**
 System Message Configuration
 */
@property(strong, nonatomic, readonly) SystemMessageConfiguration *systemMessageConfig;

/**
 Queue View Configuration
 */
@property(strong, nonatomic, readonly) InfoViewConfiguration *queueViewConfig;

/**
Search View Configuration
*/
@property(strong, nonatomic, readonly) SearchViewConfiguration *searchViewConfig;

/**
Read More View Configuration
*/
@property(strong, nonatomic, readonly) ReadMoreViewConfiguration *readMoreViewConfig;

/**
Chat Bar Configuration
*/
@property(strong, nonatomic, readonly) ChatBarConfiguration *chatBarConfiguration;

/**
VoiceToVoiceConfiguration
*/
@property(strong, nonatomic, readonly) VoiceToVoiceConfiguration *voiceToVoiceConfiguration;

/**
Bold Live Form Configuration
*/
@property(strong, nonatomic, readonly) BoldFormConfiguration *formConfiguration;
@end
