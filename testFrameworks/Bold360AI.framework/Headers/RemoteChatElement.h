
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "ContentChatElement.h"
#import <BoldAIEngine/NRConversationalResponse.h>

/**
 An RemoteMessageType is an enum of different Message Types
 */
typedef NS_ENUM(NSInteger, RemoteMessageType) {
    RemoteMessageTypDefault = 0,
    RemoteMessageTypWelcomeMessage = 1,
    RemoteMessageTypFAQ= 2
};

@interface RemoteChatElement: ContentChatElement
/**
 The remote message type
 */
@property (nonatomic, readonly) RemoteMessageType remoteMessageType;
- (instancetype)initWithRespone:(NRConversationalResponse *)response statementScope:(StatementScope)statementScope;
@end
