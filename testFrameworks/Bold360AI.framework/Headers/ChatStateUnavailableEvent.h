
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "ChatStateEvent.h"
#import <BoldEngine/BCUnavailableReason.h>

@interface ChatStateUnavailableEvent : ChatStateEvent

@property (nonatomic) BCUnavailableReason reason;
@property (nonatomic, assign) BOOL isFollowedByForm;

- (instancetype)initWithState:(ChatState)state
                        scope:(StatementScope)scope
                      dataMsg:(NSString *)msg
                       reason:(BCUnavailableReason)reason
                followedByForm:(BOOL)isFollowedByForm;

@end
