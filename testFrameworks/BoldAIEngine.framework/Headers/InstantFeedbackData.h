
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import "ArticleMeta.h"
#import "NRQueryResult.h"

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - InstantFeedbackData
/************************************************************/

@interface InstantFeedbackData : NSObject
- (instancetype _Nullable)initWithArticleMeta:(ArticleMeta *)meta;
@property (nonatomic, assign, getter=isVisible, readonly) BOOL visibility;
@property (nonatomic, assign, getter=isEnabled, readonly) BOOL enabled;
@property (nonatomic, assign, readonly) LikeState state;
@property (nonatomic, copy, readonly) NSDictionary *instantfeedbackParams;
@end

NS_ASSUME_NONNULL_END
