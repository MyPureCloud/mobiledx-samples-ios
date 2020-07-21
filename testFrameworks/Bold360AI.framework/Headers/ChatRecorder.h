
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "ChatElementDelegate.h"

@interface ChatRecorder : NSObject <ChatElementDelegate>
/**
 Parse stored elements into string.
 
 @return returns parsed string from chet elements.
 */
- (NSString *)transcript;
@end
