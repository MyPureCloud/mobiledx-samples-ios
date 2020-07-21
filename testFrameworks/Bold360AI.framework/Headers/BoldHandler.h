
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// NanorepUI SDK.
// All rights reserved.
// ===================================================================================================

#import "BaseChatHandler.h"
#import <BoldEngine/BoldEngine.h>
#import <Bold360AI/ContentChatElement.h>
#import "BLDError.h"
#import "LiveAccount.h"

static NSString * const VisitorID = @"VisitorID";
static NSString * const ChatID = @"ChatID";

/************************************************************/
// MARK: - BoldHandler
/************************************************************/

@interface BoldHandler : BaseChatHandler

/************************************************************/
// MARK: - Properties
/************************************************************/

@property (nonatomic, strong) id<BCCancelable> createChatCancelable;
@property (nonatomic, strong) id<BCChatSession> chatSession;

/************************************************************/
// MARK: - Functions
/************************************************************/

- (void)presentMsg:(NSString *)msg designType:(NSString *)designType;
- (void)presentSystemMsg:(NSString *)msg removable:(BOOL)removable;
- (void)addChatDelegation;
- (void)handleError:(BLDError *)error;
- (instancetype)initWithAccount:(LiveAccount *)account;
- (void)handleChatFinished;

@end
