
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "StorableChatElement.h"
NS_ASSUME_NONNULL_BEGIN

@interface TextToSpeechParser : NSObject
/**
Parse article text.

@return returns a parsed string.
*/
- (NSString *)parseArticleText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
