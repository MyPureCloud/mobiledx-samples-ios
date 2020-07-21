
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import "NRBaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - ConversationSettings
/************************************************************/

@interface ConversationSettings: NRBaseResponse
@property (nonatomic, assign) BOOL requireAPIKey;
@property (nonatomic, assign) BOOL channelsEnabled;
@property (nonatomic, assign) BOOL feedbackEnabled;
// Instant Feedback Indicator
@property (nonatomic, assign) BOOL feedbackPerAnswer;
@property (nonatomic, assign) NSTimeInterval feedbackTimeout;
@property (nonatomic, copy) NSString *feedbackText;
@property (nonatomic, assign) BOOL askAgent;
@property (nonatomic, assign) BOOL showSupportCenterLink;
@property (nonatomic, copy) NSString *multiResultsHeader;
@end

NS_ASSUME_NONNULL_END
