
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import "NRBaseResponse.h"
#import <UIKit/UIKit.h>

@interface NRAutoCompleteResponse : NRBaseResponse
@property (nonatomic, readonly, copy) NSArray<NSAttributedString *> *suggestions;
@property (nonatomic, readonly, copy) NSArray<NSDictionary<NSString*, id<NSCopying>> *> *suggestionsVerbose;
@property (nonatomic, copy) UIFont *font;
@property (nonatomic, copy) NSString *query;
@end
