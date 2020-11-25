
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "TrackingDatasource.h"
#import "EventParams.h"
#import "TrackParamsConstants.h"
#import "EventParamsComponent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EventTracker <NSObject>

@property (nonatomic, copy) NSMutableDictionary<NSString *, EventParamsComponent *(^)(NSString *eventName)> *events;
@property(nonatomic, weak) id<TrackingDatasource> datasource;

- (id)initWithDatasource:(id<TrackingDatasource>) aDatasource;
- (void)trackEvent:(NSString *)eventName;
- (BOOL)trackingIsEnabled:(TrackQueryParameter) trackQueryParameter;
- (void)onSamplingLevelChanged:(Float64 *)eventTrackingSamplingLevel;
@end

NS_ASSUME_NONNULL_END
