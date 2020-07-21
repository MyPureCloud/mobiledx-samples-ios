
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "ChatHandler.h"

/************************************************************/
// MARK: - BaseChatHandler
/************************************************************/

@interface BaseChatHandler : NSObject <ChatHandler, TrackingDatasource>

- (void)presentStatement:(id<StorableChatElement>)statement;
- (void)presentFeedbackStatement:(id<StorableChatElement> _Nonnull)statement;

- (void)updateStatus:(StatementStatus)status element:(id<StorableChatElement>)element;
- (void)preparePreChatInfo:(PreChatInfo *)info;
- (void)updateChatState:(ChatStateEvent *)event;
@end
