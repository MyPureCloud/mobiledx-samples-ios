
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "SupportCenterDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SupportCenterBase <NSObject>
@property (nonatomic, strong) SupportCenterDataSource *dataHandler;
@property (nonatomic, strong) id<SupportCenterItem> item;
- (void)back;
@end

NS_ASSUME_NONNULL_END
