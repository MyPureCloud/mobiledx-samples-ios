
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "TrackingDatasource.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventParams : NSObject

@property(nonatomic, copy) NSMutableDictionary<NSString *, NSString *> *params;

- (instancetype)initWithDatasource: (id<TrackingDatasource>)datasource;

@end

NS_ASSUME_NONNULL_END
