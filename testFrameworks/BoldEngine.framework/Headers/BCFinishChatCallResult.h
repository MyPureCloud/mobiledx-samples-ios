
// NanorepUI version number: v2.4.5 

//
//  BCFinishChatCallResult.h
//  VisitorSDK
//
//  Created by Viktor Fabian on 4/2/14.
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCRESTCallResult.h"

@interface BCFinishChatCallResult : BCRESTCallResult

@property(nonatomic, copy)NSArray *postChat;
//will contain more when post chat is implemented

@end
