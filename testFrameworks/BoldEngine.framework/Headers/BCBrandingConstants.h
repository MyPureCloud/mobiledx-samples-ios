
// NanorepUI version number: v2.4.8 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - PreChat Global Branding Keys
/************************************************************/

static const struct ChatBrandingReadable {
    __unsafe_unretained NSString *introMessage;
    __unsafe_unretained NSString *startChat;
    __unsafe_unretained NSString *required;
    __unsafe_unretained NSString *departmentAvailable;
    __unsafe_unretained NSString *departmentUnavailable;
    __unsafe_unretained NSString *invalidEmail;
    __unsafe_unretained NSString *invalidPhoneNumber;
    __unsafe_unretained NSString *invalidInput;
    __unsafe_unretained NSString *chatEnded;
    __unsafe_unretained NSString *waitingForOperator;
    __unsafe_unretained NSString *chatEnd;
    __unsafe_unretained NSString *chatOperatorEnded;
    __unsafe_unretained NSString *chatDisconnected;
    __unsafe_unretained NSString *chatSendMessage;
    __unsafe_unretained NSString *chatOperator;
    __unsafe_unretained NSString *errorMessage;
    __unsafe_unretained NSString *errorMessageOversize;
    __unsafe_unretained NSString *unsecure;
    __unsafe_unretained NSString *noOperators;
    __unsafe_unretained NSString *outsideHours;
    __unsafe_unretained NSString *userBlocked;
    __unsafe_unretained NSString *queueFull;
    __unsafe_unretained NSString *reachedLimit;
    __unsafe_unretained NSString *unknown;
} ChatBranding, UnavailableBranding, PreChatBranding, PostChatBranding, ChatBarBranding, FileUploadError;

static const struct ChatBrandingReadable ChatBranding = {
    .departmentAvailable = @"api#department#available",
    .departmentUnavailable = @"api#department#unavailable",
    .invalidEmail = @"api#email#error",
    .invalidPhoneNumber = @"api#phone#error",
    .invalidInput = @"api#input#error",
    .required = @"api#prechat#required",
    .chatEnded = @"api#chat#ended",
    .chatOperatorEnded = @"api#chat#operator_ended",
    .waitingForOperator = @"api#chat#waiting_for_operator",
    .chatDisconnected = @"api#chat#disconnected",
    .chatSendMessage = @"api#chat#send_message"
};

static const struct ChatBrandingReadable UnavailableBranding = {
    .introMessage = @"api#unavailable#intro",
    .startChat = @"api#chat#close",
    .unsecure = @"api#unsecure#message",
    .noOperators = @"api#unavailable#no_operators",
    .outsideHours = @"api#unavailable#unavailable_hours_operators",
    .userBlocked = @"api#unavailable#unavailable_blocked",
    .queueFull = @"api#unavailable#unavailable_max_queue",
    .reachedLimit = @"api#unavailable#unavailable_limit",
    .unknown = @"api#unavailable#unavailable"
};

static const struct ChatBrandingReadable PreChatBranding = {
    .introMessage = @"api#prechat#intro",
    .startChat = @"api#prechat#start"
};

static const struct ChatBrandingReadable PostChatBranding = {
    .introMessage = @"api#postchat#intro",
    .startChat = @"api#postchat#done"
};

static const struct ChatBrandingReadable ChatBarBranding = {
    .chatEnd = @"api#chat#end",
    .chatOperator = @"api#chat#operator"
};

static const struct ChatBrandingReadable FileUploadError = {
    .errorMessage = @"custom#common#chat_window#send_file_error_message",
    .errorMessageOversize = @"custom#common#chat_window#send_file_error_message_oversize"
};

@interface BCBrandingConstants : NSObject
+ (NSDictionary *)updateBrandings:(NSDictionary *)branding;
@end

NS_ASSUME_NONNULL_END
