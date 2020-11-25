
// NanorepUI version number: v3.8.10 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "AsyncMessage.h"
#import "AsyncAccount.h"
#import "ChatHandler.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MessageResponseType) {
    MessageResponseTypeChatUNKNOWN,
    MessageResponseTypeChatStarted,
    MessageResponseTypeChatStartFailed,
    MessageResponseTypeFailed,
    MessageResponseTypeSuccess,
    MessageResponseTypeSend,
    MessageResponseTypeReceived,
    MessageResponseTypeEnd,
    MessageResponseTypeDisconnected
};

@protocol MessageQueueDelegate <NSObject>
- (void)message:(AsyncMessage *)message
         status:(MessageResponseType)status
          error:(NSError * _Nullable)error;
- (void)didReceiveMessage:(id<StorableChatElement>)message;
- (void)updateStatus:(StatementStatus)status element:(id<StorableChatElement>)chatElement;
- (void)updateAgentBar:(BCPerson *)person;
@end

@interface MessageQueue : NSObject
- (instancetype)initWithAccount:(AsyncAccount *)account;
@property (nonatomic, weak) id<MessageQueueDelegate> delegate;

// TODO: Enable setter from app (Continuity)
@property (nonatomic, copy, readonly) NSString *sender;
- (void)postChatElement:(id<StorableChatElement>)chatElement;
- (void)sendMessage:(AsyncMessage *)message;
- (void)checkResponse:(AsyncResponse *)response;

@end

NS_ASSUME_NONNULL_END
