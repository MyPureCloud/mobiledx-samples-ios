
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "ChatEvent.h"

extern NSString *const ChatFormExist;

/**
 An ChatState is an enum of different chat states in chat lifecycle.
 */
typedef NS_ENUM(NSInteger, ChatState) {
    /// Initial state, once the chat creation has started.
    ChatPreparing,
    /// When the chat was successfully started (not yet accepted by agent).
    /// At this point the User can start posting messages on the chat.
    ChatStarted,
    /// User chat was assigned to an agent, and waiting for an agent acceptance.
    ChatPending,
    /// User chat is in the waiting queue, and waiting to be assigned to an agent.
    /// In this event the position in the queue is passed.
    ChatInQueue,
    /// Agent accepted & Live chat started.
    ChatAccepted,
    /// Live Chat ending.
    ChatEnding,
    /// Live Chat ended.
    ChatEnded,
    /// Live Chat unavailable.
    ChatUnavailable
};


@interface ChatStateEvent : ChatEvent

@property (nonatomic) ChatState state;
@property (nonatomic, copy) NSString *dataMsg;

- (instancetype)initWithState:(ChatState)state
                        scope:(StatementScope)scope
                      dataMsg:(NSString *)msg;

@end

