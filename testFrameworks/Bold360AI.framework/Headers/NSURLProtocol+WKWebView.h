
// NanorepUI version number: v3.8.10 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

@interface NSURLProtocol (BLDWKWebView)


+ (void)bld_registerScheme:(NSString *)scheme;


+ (void)bld_unregisterScheme:(NSString *)scheme;
@end
