
// NanorepUI version number: v2.4.8 

//
//  BCGetChatAvailabilityCall.h
//  VisitorSDK
//
//  Created by Viktor Fabian on 4/9/14.
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCGetChatAvailabilityCallResult.h"
#import "BCCall.h"

@class BCGetChatAvailabilityCall;
@class BCGetChatDepartmentsCall;

@protocol BCGetChatAvailabilityCallDelegate <NSObject>
- (void)bcGetChatAvailabilityCall:(BCGetChatAvailabilityCall *)getChatAvailabilityCall didFinishWithResult:(BCGetChatAvailabilityCallResult *)result;
- (void)bcGetChatAvailabilityCall:(BCGetChatAvailabilityCall *)getChatAvailabilityCall didFinishWithError:(NSError *)error;
@end

@protocol BCGetChatDepartmentsCallDelegate <NSObject>
- (void)bcGetChatDepartmentsCall:(BCGetChatDepartmentsCall *)getChatDepartmentsCall didFinishWithResult:(BCGetChatDepartmentsCallResult *)result;
- (void)bcGetChatDepartmentsCall:(BCGetChatDepartmentsCall *)getChatdepartmentsCall didFinishWithError:(NSError *)error;
@end

@interface BCGetChatAvailabilityCall : BCCall

@property(nonatomic, copy) NSString *visitorId;
@property(nonatomic, copy) NSString *departmentId;
@property(nonatomic, weak) id<BCGetChatAvailabilityCallDelegate> delegate;

@end

@interface BCGetChatDepartmentsCall : BCCall

@property(nonatomic, copy) NSString *visitorId;
@property(nonatomic, weak) id<BCGetChatDepartmentsCallDelegate> delegate;

@end
