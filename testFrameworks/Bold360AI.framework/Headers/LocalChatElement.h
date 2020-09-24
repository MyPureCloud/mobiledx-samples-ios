
// NanorepUI version number: v3.8.4 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "ContentChatElement.h"

@interface LocalChatElement : ContentChatElement

- (instancetype)initWithContent:(NSString *)content;
/**
 The input type the user used e.g. AutoComplete
 */
@property (nonatomic, copy) NSString *userInputType;
@property (nonatomic, copy) NSString *userTrackingType;
@property (nonatomic, copy) NSString *postback;
@property (nonatomic, copy, readonly) NSArray<NSURLQueryItem *> *queryItems;
@end
