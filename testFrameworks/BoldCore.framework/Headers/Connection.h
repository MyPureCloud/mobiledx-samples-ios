
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "Future.h"
#import "BURLRequest.h"

NS_ASSUME_NONNULL_BEGIN


@interface Connection<A> : NSObject

+ (Future<A> *)objectTask:(NSURLRequest *)request;
+ (Future<A> *)dataTask:(NSURLRequest *)request;

+ (Result<NSDictionary *> *)parseToObject:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
