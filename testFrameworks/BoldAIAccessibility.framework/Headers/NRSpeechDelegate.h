
// NanorepUI version number: v1.7.2 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// BoldAIAccessibility SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

@protocol NRSpeechDelegate <NSObject>
- (void)recordDidEnd;
- (void)speechDetected:(NSString *)text;
@end
