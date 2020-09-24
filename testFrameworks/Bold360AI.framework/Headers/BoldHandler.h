
// NanorepUI version number: v3.8.4 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// NanorepUI SDK.
// All rights reserved.
// ===================================================================================================

#import "BaseChatHandler.h"
#import <BoldEngine/BoldEngine.h>
#import "BLDError.h"
#import "LiveAccount.h"
#import "RemoteChatElement.h"

static NSString * _Nonnull const VisitorID = @"VisitorID";
static NSString * _Nonnull const ChatID = @"ChatID";

/************************************************************/
// MARK: - BoldHandler
/************************************************************/

@interface BoldHandler : BaseChatHandler

/************************************************************/
// MARK: - Properties
/************************************************************/

@property (nonatomic, strong) id<BCCancelable> _Nullable createChatCancelable;
@property (nonatomic, strong) id<BCChatSession> _Nullable chatSession;

/************************************************************/
// MARK: - Functions
/************************************************************/

- (void)presentMsg:(NSString *_Nonnull)msg designType:(NSString *_Nonnull)designType;
- (void)presentSystemMsg:(RemoteChatElement *_Nonnull)element;
- (void)addChatDelegation;
- (void)handleError:(BLDError *_Nullable)error;
- (instancetype _Nullable)initWithAccount:(LiveAccount *_Nonnull)account;
- (void)handleChatFinishedWithMessage:(NSString *_Nullable)msg;

@end
