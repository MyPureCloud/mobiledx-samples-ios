
// NanorepUI version number: v2.4.5 

//
//  BCOSSNotification.h
//  VisitorSDK
//
//  Created by Viktor Fabian on 3/31/14.
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCOSSNotification : NSObject

- (BOOL)processMessage:(NSDictionary *)message;

@end
