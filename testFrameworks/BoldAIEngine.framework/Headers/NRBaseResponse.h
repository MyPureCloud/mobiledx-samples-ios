
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

@interface NRBaseResponse : NSObject
- (instancetype)initWithParams:(NSDictionary *)params;
- (void)inflate:(NSDictionary *)params;
@end
