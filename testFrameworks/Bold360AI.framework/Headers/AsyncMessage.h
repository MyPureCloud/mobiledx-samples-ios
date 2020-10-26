
// NanorepUI version number: v3.8.7. 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const ConversationMsg = @"conversation";
static NSString * const ConversationAckMsg = @"conversation-ack";
static NSString * const MessageMsg = @"agent-answer";
static NSString * const HistoryMsg = @"history";
static NSString * const GetHistoryMsg = @"get-history";
static NSString * const HistoryAckMsg = @"get-history-ack";
static NSString * const StartChatMsg = @"start-chat";
static NSString * const FinishChatMsg = @"finish-chat";
static NSString * const StartChatAckMsg = @"start-chat-ack";
static NSString * const FinishChatAckMsg = @"finish-chat-ack";
static NSString * const ErrorMsg = @"error";
static NSString * const Disconnected = @"disconnected";

@interface JSONObject : NSObject
- (instancetype)initWithJson:(NSDictionary *)json;
@property (nonatomic, copy) NSDictionary *json;
@end

@interface UserInfo : JSONObject
- (instancetype)initWithUserId:(NSString *)userId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *countryAbbrev;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *profilePic;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *messageId;

@end

@interface Content : JSONObject
@property (nonatomic, readonly) NSTimeInterval timestamp;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *lastReceivedMessageID;
@property (nonatomic, copy) UserInfo *userInfo;
@end

@interface Payload : JSONObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) Content *content;
@end

@interface AsyncMessage : JSONObject

+ (AsyncMessage *)endChatOperator;
+ (AsyncMessage *)endChatMessage;
+ (AsyncMessage *)startChatMessage;
+ (AsyncMessage *)disconnectedMessage;
+ (AsyncMessage *)historyMessage;

@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *application;
@property (nonatomic, strong) Payload *payload;
@property (nonatomic, copy, readonly) NSString *branding;
@end

@interface AsyncResponse : JSONObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *responseTo;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSNumber *timestamp;
@end


NS_ASSUME_NONNULL_END
