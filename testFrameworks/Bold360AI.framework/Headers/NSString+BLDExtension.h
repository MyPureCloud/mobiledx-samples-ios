
// NanorepUI version number: v3.8.4 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

@interface NSString (BLDExtension)

/**
 SHA1
 
 @param string string to sha1
 @return returns str after sha1
 */
+ (NSString *)bld_SHA1FromString:(NSString *)string;
@end
