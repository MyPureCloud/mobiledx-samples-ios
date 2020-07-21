
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <BoldAIEngine/ReadoutMessage.h>

@protocol ReadoutHandler <NSObject>
- (id <ReadoutMessage>)shouldReplaceReadoutMessage:(id <ReadoutMessage>)readoutMessage;
@end
