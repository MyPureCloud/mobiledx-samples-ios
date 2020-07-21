
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "StorableChatElement.h"
#import <BoldAIEngine/FeedbackConfiguration.h>
#import <BoldAIEngine/NRConversationalResponse.h>
#import "RemoteChatElement.h"
#import <BoldAIEngine/FeedbackItem.h>

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - InstantFeedbackHandlerProvider
/************************************************************/

@protocol InstantFeedbackHandlerProvider <NSObject>
- (void)handleResponse:(NRConversationalResponse *_Nullable)response
                 error:(NSError *_Nullable) error;
- (void)presentFeedbackStatement:(id<StorableChatElement>)statement;
- (void)updateFeedbackModeEnabled;
@end

/************************************************************/
// MARK: - InstantFeedbackHandler
/************************************************************/

@interface InstantFeedbackHandler : NSObject

/// Initialization method.
- (instancetype)initWithParams:(InstantFeedbackConfiguration *)feedbackConfiguration;
/// Add feedback according to user's choice.
- (void)didClickFeedback:(FeedbackItem *)item;
/// Add feedback view;
- (void)addFeedback:(NRConversationalResponse *)response;
/// The instant feedback handler delegate.
@property(nonatomic, weak) id<InstantFeedbackHandlerProvider> _Nullable delegate;
/// Should get chat input query as feedback, without sending to server.
@property (nonatomic, assign, readonly) BOOL isFeedbackModeEnabled;
@end

NS_ASSUME_NONNULL_END
