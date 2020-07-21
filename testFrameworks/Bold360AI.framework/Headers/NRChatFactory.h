
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "ChatHandler.h"
#import <BoldCore/Account.h>

@interface NRChatFactory : NSObject
+ (id<ChatHandler>)createChatHandlerForAccount:(Account *)account;
@end
