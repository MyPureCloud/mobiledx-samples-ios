
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NRChanneling.h"
#import "NRQueryResult.h"


@interface NSDictionary (Parsed)
/// Parse to wrapped.
@property (nonatomic, readonly, copy) NSString *wrapped;
/// Parse to query.
@property (nonatomic, readonly, copy) NSString *asQuery;
/// Parse to json.
@property (nonatomic, readonly, copy) NSString *inJSON;

/// Parse auto complete.
/// @param font the font.
- (NSArray<NSAttributedString *> *)parseAutoComplete:(UIFont *)font;
@end
