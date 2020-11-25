
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrameComponents : NSObject
@property (nonatomic, copy) NSString *command;
@property (nonatomic, copy) NSMutableDictionary<NSString *, NSString *> *headers;
@property (nonatomic, copy) NSString *body;
@end

NS_ASSUME_NONNULL_END
