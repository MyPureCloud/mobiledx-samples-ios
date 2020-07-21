
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "LiveAccount.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AccountProvider <NSObject>
@property (nonatomic, readonly) AccountExtraData *accountExtraData;
@end

NS_ASSUME_NONNULL_END
