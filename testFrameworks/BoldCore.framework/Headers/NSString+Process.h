
// NanorepUI version number: v3.4.1 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "FrameComponents.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Process)
@property (nonatomic, readonly) FrameComponents *processString;
@property (nonatomic, readonly, copy) id toJson;
- (NSMutableDictionary<NSString *, NSString *> *)headerToSend:(NSString *)headerName;
@end

NS_ASSUME_NONNULL_END
