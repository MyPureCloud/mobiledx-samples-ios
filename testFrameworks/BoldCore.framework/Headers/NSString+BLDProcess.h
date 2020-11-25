
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "FrameComponents.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BLDProcess)
@property (nonatomic, readonly) FrameComponents *bld_ProcessString;
@property (nonatomic, readonly, copy) id bld_ToJson;
- (NSMutableDictionary<NSString *, NSString *> *)bld_HeaderToSend:(NSString *)headerName;
@end

NS_ASSUME_NONNULL_END
