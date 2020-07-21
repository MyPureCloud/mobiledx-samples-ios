
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <BoldAIAccessibility/NRSpeechRecognizerAuthorizationStatus.h>

@protocol SpeechReconitionDelegate <NSObject>

/// Status of asking permission to use speech recognition.
- (void)speechRecognitionStatus:(NRSpeechRecognizerAuthorizationStatus)status;

/// Speech recognition was requested while not authorized,
/// at this point settings alert should be presented to enable speech.
- (void)speechRecognitionNotAuthorizedRequset;
@end
