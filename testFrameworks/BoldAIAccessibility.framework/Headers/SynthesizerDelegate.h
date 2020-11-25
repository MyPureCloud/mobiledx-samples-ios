
// NanorepUI version number: v1.7.2 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SynthesizerDelegate <NSObject>
- (void)didFinishReadout:(BOOL)state;
@end

NS_ASSUME_NONNULL_END
