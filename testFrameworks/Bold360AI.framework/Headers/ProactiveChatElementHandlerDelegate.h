
// NanorepUI version number: v3.8.7. 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#ifndef ProactiveChatElementHandlerDelegate_h
#define ProactiveChatElementHandlerDelegate_h

#import "StorableChatElement.h"

/************************************************************/
// MARK: - ProactiveChatElementHandlerDelegate
/************************************************************/

@protocol ProactiveChatElementHandlerDelegate <NSObject>
- (void)present:(id<StorableChatElement> _Nonnull)statement;
- (void)post:(id<StorableChatElement> _Nonnull)statement;
@end

#endif /* ProactiveChatElementHandlerDelegate_h */
