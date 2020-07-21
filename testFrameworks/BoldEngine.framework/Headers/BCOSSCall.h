
// NanorepUI version number: v2.4.5 

//
//  BCOSSCall.h
//  VisitorSDK
//
//  Created by Viktor Fabian on 3/31/14.
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCOSSCall : NSObject

@property(strong)NSString *callId;

//public
- (NSData *)requestData;
- (BOOL)waitsForResponse;
- (BOOL)processResponse:(NSDictionary *)response;

//protected
- (NSData *)requestWithMethod:(NSString *)method params:(NSDictionary *)params;

@end
