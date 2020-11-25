
// NanorepUI version number: v1.7.2 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// BoldAIAccessibility SDK.
// All rights reserved.
// ===================================================================================================


#import <Foundation/Foundation.h>
#import "SynthesizerConfiguration.h"
#import "SynthesizerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Synthesizer : NSObject

@property (nonatomic) SynthesizerConfiguration * _Nullable configuration;
@property (nonatomic) BOOL shouldRead;
@property (nonatomic, weak) id<SynthesizerDelegate> _Nullable delegate;
- (instancetype)initWithConfiguration:(SynthesizerConfiguration *)configuration;
- (BOOL)read:(NSString *)text;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
