
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "ChatElement.h"

@interface PreChatInfo : NSObject
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, readwrite) NSArray<id<ChatElement>> *elements;
@property (nonatomic, copy) NSString *chatTranscript;
@property (nonatomic, copy) NSDictionary *extraInfo;
@end
