
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "ProactiveChatElement.h"

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - ProactiveChatElementHandler
/************************************************************/

@interface ProactiveChatElementHandler : NSObject
/// Helps to inject messages into the chat.
/// @param element The chat element to be injected.
- (void)post:(ProactiveChatElement *)element;
@end


NS_ASSUME_NONNULL_END
