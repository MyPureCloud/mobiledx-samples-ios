
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// An InputType is an enum of different user input types
typedef NS_ENUM(NSInteger, InputType) {
    /// Sent when Voice input was used.
    ConversationVoice = 0,
    /// Sent when AutoComplete was used.
    BotAutoComplete = 1,
    /// Not sent.
    Keyboard = 2,
    /// Not sent.
    AppInjection = 3,
    InputTypesCount // keep track of the enum size automatically
};

extern NSString * _Nonnull const InputTypes[InputTypesCount];

@interface TrackingUsageConstants : NSObject
@property (nonatomic, assign) InputType inputType;
@end
NS_ASSUME_NONNULL_END
