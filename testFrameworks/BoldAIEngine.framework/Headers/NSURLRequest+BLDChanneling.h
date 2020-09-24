
// NanorepUI version number: v1.8.5 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

@interface NSURLRequest (BLDChanneling)
@property (nonatomic, readonly) BOOL bld_IsNanorep;
@property (nonatomic, readonly) NSInteger bld_Type;
@property (nonatomic, copy, readonly) NSString *bld_Result;
@property (nonatomic, copy, readonly) NSDictionary *bld_FormData;
@end
