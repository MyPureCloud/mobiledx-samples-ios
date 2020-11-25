
// NanorepUI version number: v1.7.2 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "SynthesizerConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// An enum of different voice-to-voice readout options
typedef NS_ENUM(NSInteger, VoiceToVoiceType) {
    /// Whether or not to automaticly send a recorded message and readout the message recived from the server.
    VoiceToVoiceTypeDefault = 0,
    /// Whether or not to automaticly send a recorded message, readout the message recived from the server and then start recording again.
    VoiceToVoiceTypeHandsFreeMode = 1
};


@interface VoiceToVoiceConfiguration : NSObject
// The STT and TTS type
@property(nonatomic) VoiceToVoiceType type;
// The time that needs to pass in silence before the past dictated text is sent.
@property(nonatomic) double silenceTimeBeforeMessageSent;
// Synthesizer Configuration.
@property (strong, nonatomic, readonly) SynthesizerConfiguration * _Nonnull synthesizerConfiguration;
@end

NS_ASSUME_NONNULL_END
