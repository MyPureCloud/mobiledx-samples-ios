
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const commandConnect = @"CONNECT";
static NSString * const commandSend = @"SEND";
static NSString * const commandSubscribe = @"SUBSCRIBE";
static NSString * const commandUnsubscribe = @"UNSUBSCRIBE";
static NSString * const commandBegin = @"BEGIN";
static NSString * const commandCommit = @"COMMIT";
static NSString * const commandAbort = @"ABORT";
static NSString * const commandAck = @"ACK";
static NSString * const commandDisconnect = @"DISCONNECT";
static NSString * const commandPing = @"\n";

//static NSString * const controlChar = String(format: @"%C", arguments: [0x00])

// Ack Mode
static NSString * const ackClientIndividual = @"client-individual";
static NSString * const ackClient = @"client";
static NSString * const ackAuto = @"auto";
// Header Commands
static NSString * const commandHeaderReceipt = @"receipt";
static NSString * const commandHeaderDestination = @"destination";
static NSString * const commandHeaderDestinationId = @"id";
static NSString * const commandHeaderContentLength = @"content-length";
static NSString * const commandHeaderContentType = @"content-type";
static NSString * const commandHeaderAck = @"ack";
static NSString * const commandHeaderTransaction = @"transaction";
static NSString * const commandHeaderMessageId = @"id";
static NSString * const commandHeaderSubscription = @"subscription";
static NSString * const commandHeaderDisconnected = @"disconnected";
static NSString * const commandHeaderHeartBeat = @"heart-beat";
static NSString * const commandHeaderAcceptVersion = @"accept-version";
// Header Response Keys
static NSString * const responseHeaderSession = @"session";
static NSString * const responseHeaderReceiptId = @"receipt-id";
static NSString * const responseHeaderErrorMessage = @"message";
// Frame Response Keys
static NSString * const responseFrameConnected = @"CONNECTED";
static NSString * const responseFrameMessage = @"MESSAGE";
static NSString * const responseFrameReceipt = @"RECEIPT";
static NSString * const responseFrameError = @"ERROR";

typedef NS_ENUM(NSInteger, StompAckMode) {
    StompAckModeAutoMode,
    StompAckModeClientMode,
    StompAckModeClientIndividualMode
};

@class StompClient;
@protocol StompClientDelegate <NSObject>

- (void)stompClient:(StompClient *)client
didReceiveMessageWithJSONBody:(id)jsonBody
      akaStringBody:(NSString *)stringBody
        withHeaders:(NSDictionary<NSString *, NSString *> *)headers
    withDestination:(NSString *)destination;

- (void)stompClientDidDisconnect:(StompClient *)client;

- (void)stompClientDidConnect:(StompClient *)client;

- (void)stompClient:(StompClient *)client serverDidSendReceipt:(NSString *)receiptId;

- (void)stompClient:(StompClient *)client
serverDidSendErrorWithMessage:(NSString *)errorDescription
withDetailedErrorMessage:(NSString *)message;
- (void)serverDidSendPing;

@end

@interface StompClient : NSObject
@property (nonatomic, weak) id<StompClientDelegate> delegate;
@property (nonatomic, assign, getter=isConnected) BOOL connection;
@property (nonatomic, assign) BOOL certificateCheckEnabled;

- (void)sendJSONForDict:(NSDictionary<NSString *, id> *)dict toDestination:(NSString *)destination;

- (void)openSocketWithURLRequest:(NSURLRequest *)request
                        delegate:(id<StompClientDelegate>)delegate
               connectionHeaders:(NSDictionary<NSString *, NSString *>  * _Nullable )connectionHeaders;

- (void)sendMessage:(NSString *)message
      toDestination:(NSString *)destination
        withHeaders:(NSDictionary<NSString *, NSString *> *)headers
        withReceipt:(NSString * _Nullable)receipt;

- (void)subscribe:(NSString *)destination;

- (void)subscribeToDestination:(NSString *)destination
                       ackMode:(StompAckMode)ackMode;

- (void)subscribeWithHeader:(NSDictionary<NSString *, NSString *> *)header
                destination:(NSString *)destination;

- (void)unsubscribe:(NSString *)destination;

- (void)beginWithTransactionId:(NSString *)transactionId;

- (void)commitWithTransactionId:(NSString *)transactionId;

- (void)abortWithTransactionId:(NSString *)transactionId;

- (void)ackWithMessageId:(NSString *)messageId;

- (void)ackWithMessageId:(NSString *)messageId withSubscription:(NSString *)subscription;

- (void)disconnect;

- (void)reconnect:(NSURLRequest *)request
         delegate:(id<StompClientDelegate>)delegate
connectionHeaders:(NSMutableDictionary<NSString *, NSString *> *)connectionHeaders
             time:(NSTimeInterval)time
exponentialBackoff:(BOOL)exponentialBackoff;

- (void)autoDisconnect:(NSTimeInterval)time;
@end

NS_ASSUME_NONNULL_END
