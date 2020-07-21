
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <BoldAIAccessibility/BoldAIAccessibility.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SearchViewControllerDelegate <NSObject>
@optional
- (void)didSelectSuggestion:(NSDictionary<NSString *, id<NSCopying>> *)suggestion;

/**
 Text was submitted.
 
 @param text content text
 */
- (void)didSubmitText:(NSString *)text;

- (void)isTyping:(BOOL)isTyping;

- (void)didClickUploadFile;
/**
 Speech Recognition Did Fail.
 */
- (void)speechRecognitionDidFailWithStatus:(NRSpeechRecognizerAuthorizationStatus)status;
/**
 TTS stoped.
 */
- (void)shouldStopReadout:(BOOL)shouldStopReadout;

@end


NS_ASSUME_NONNULL_END
