
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "ReadoutOption.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ReadoutMessage <NSObject>
@property (nonatomic, copy) NSString * _Nullable body;
@property (nonatomic, copy) NSMutableArray <id <ReadoutOption>> * _Nullable quickOptions;
@property (nonatomic, copy) NSMutableArray<id <ReadoutOption>> *  _Nullable persistentOptions;
@end

NS_ASSUME_NONNULL_END
