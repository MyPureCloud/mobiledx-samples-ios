
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

@interface NRLikeStateHandler : NSObject
- (void)updateLikeState:(BOOL)likeState ForId:(NSString *)articleId;
- (NSNumber *)likeStateWithId:(NSString *)articleId;
- (void)clear;
@end
