
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <BoldAIEngine/NROptionKind.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ReadoutOption <NSObject>
@property (nonatomic, copy) NSString * _Nullable body;
@property (nonatomic) NROptionKind kind;
@end

NS_ASSUME_NONNULL_END
