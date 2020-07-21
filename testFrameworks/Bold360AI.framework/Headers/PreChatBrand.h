
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// NanorepUI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

/************************************************************/
// MARK: - ChatBrand
/************************************************************/

@interface ChatBrand : NSObject
- (instancetype)initWithBranding:(NSDictionary *)branding;
@property (nonatomic, copy, readonly) NSDictionary *branding;
@property (nonatomic, copy, readonly) NSString *departmentAvailable;
@property (nonatomic, copy, readonly) NSString *departmentUnavailable;
@property (nonatomic, copy, readonly) NSString *invalidEmail;
@property (nonatomic, copy, readonly) NSString *invalidPhoneNumber;
@property (nonatomic, copy, readonly) NSString *invalidInput;
@property (nonatomic, copy, readonly) NSString *introMessage;
@property (nonatomic, copy, readonly) NSString *startChat;
@property (nonatomic, copy, readonly) NSString *required;
@end

/************************************************************/
// MARK: - PreChatBrand
/************************************************************/

@interface PreChatBrand : ChatBrand
@end

/************************************************************/
// MARK: - UnavailableBrand
/************************************************************/

@interface UnavailableBrand : ChatBrand
@end

/************************************************************/
// MARK: - PostBrand
/************************************************************/

@interface PostChatBrand : ChatBrand
@end
