
// NanorepUI version number: v3.8.4 

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

- (void)presentStatement:(id<StorableChatElement>_Nullable)statement;
- (void)presentFeedbackStatement:(id<StorableChatElement> _Nonnull)statement;

- (void)updateStatus:(StatementStatus)status element:(id<StorableChatElement>_Nullable)element;
- (void)preparePreChatInfo:(PreChatInfo *_Nullable)info;
- (void)updateChatState:(ChatStateEvent *_Nullable)event;
@end
