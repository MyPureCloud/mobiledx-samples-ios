
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "NRChannelPresentor.h"
#import <BoldAIEngine/BoldAIEngine.h>

@interface NRChannelStrategy : NSObject
+ (id<NRChannelPresentor>)fetchChannelPresentorForChannel:(NRChanneling *)channel extraData:(NSDictionary *)extraData;


@end
