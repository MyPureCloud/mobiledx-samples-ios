
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// NanorepUI SDK.
// All rights reserved.
// ===================================================================================================

#import "BoldHandler.h"

@interface BoldHandler (BCSubmitPostChatDelegate)<BCSubmitPostChatDelegate>
- (void)handleChatFinished;
- (void)handleForm:(BCForm *)form;
- (void)handleUnavailableForm:(BCForm *)unavailableForm dataMsg:(NSString *)message
                       reason:(BCUnavailableReason)reason;
@end
