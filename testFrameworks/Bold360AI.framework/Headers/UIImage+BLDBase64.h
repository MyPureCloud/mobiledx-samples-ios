
// NanorepUI version number: v3.8.7. 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>

@interface UIImage (BLDBase64)
@property (nonatomic, readonly, copy) NSString *bld_Base64;
+ (void)bld_LoadFromURL:(NSURL*)url
           callback:(void (^)(UIImage *image))callback;
@end
