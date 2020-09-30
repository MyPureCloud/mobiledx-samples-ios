
// NanorepUI version number: v1.8.6 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NRChanneling.h"
#import "NRQueryResult.h"


@interface NSDictionary (BLDParsed)
/// Parse to wrapped.
@property (nonatomic, readonly, copy) NSString *bld_Wrapped;
/// Parse to query.
@property (nonatomic, readonly, copy) NSString *bld_AsQuery;
/// Parse to json.
@property (nonatomic, readonly, copy) NSString *bld_InJSON;

/// Parse auto complete.
/// @param font the font.
- (NSArray<NSAttributedString *> *)bld_ParseAutoComplete:(UIFont *)font;
@end
