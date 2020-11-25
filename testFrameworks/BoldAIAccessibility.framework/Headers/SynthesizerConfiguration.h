
// NanorepUI version number: v1.7.2 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SynthesizerConfiguration : NSObject
//  Specifies the BCP-47 language tag that represents the voice.
/// Examples: en-US (U.S. English), fr-CA (French Canadian)
@property(nonatomic, copy) NSString *currentLanguageCode;
// The baseline pitch at which the utterance will be spoken.
@property(nonatomic) float pitchMultiplier;
// The amount of time a speech synthesizer will wait before actually speaking
@property(nonatomic) NSTimeInterval preUtteranceDelay;
// The rate at which the utterance will be spoken.
@property(nonatomic) float rate;
// The volume used when speaking the utterance.
@property(nonatomic) float volume;
@end

NS_ASSUME_NONNULL_END
