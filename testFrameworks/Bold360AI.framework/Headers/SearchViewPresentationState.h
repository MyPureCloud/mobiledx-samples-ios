
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "AutoCompleteView.h"

typedef NS_ENUM(NSInteger, PresentationState) {
    TypingPlaceholder,
    TypingSendDisabled,
    TypingSendEnabled,
    RecordingPlaceholder,
    Recording,
    Readout,
};

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewPresentationState : NSObject
- (instancetype)initWithConfiguration:(SearchViewConfiguration *)configuration;

@property (nonatomic) SearchViewConfiguration *configuration;
@property (nonatomic) PresentationState state;

@property (nonatomic, readonly) BOOL isSpeechButtonEnabled;
@property (nonatomic, readonly) BOOL isSpeechButtonHidden;
@property (nonatomic, readonly) BOOL isSendButtonEnabled;
@property (nonatomic, readonly) BOOL isSendButtonHidden;
@property (nonatomic, readonly) BOOL isKeyboardButtonHidden;
@property (nonatomic, readonly) BOOL isReadoutButtonHidden;
@property (nonatomic, readonly) BOOL isPlaceholderVisible;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, readonly) BOOL isTextViewEditable;
@property (nonatomic, copy) UIImage * _Nullable speechIcon;
@end

NS_ASSUME_NONNULL_END
