
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - FeedbackConfigType
/************************************************************/

typedef enum {
    FeedbackConfigTypePositive = 0,
    FeedbackConfigTypeNegative = 1,
    FeedbackConfigTypeBadSearch,
    FeedbackConfigTypeBadAnswer,
    FeedbackConfigTypeActionButton,
    FeedbackConfigTypeOpenText
} FeedbackConfigType;

/************************************************************/
// MARK: - HistoryItem
/************************************************************/

@interface FeedbackItem : NSObject
@property (nonatomic, copy, readonly) NSString *_Nullable text;
@property (nonatomic, copy, readonly) NSString *_Nullable feedbackText;
@property (nonatomic, readonly) FeedbackConfigType type;
@property (nonatomic, copy, readonly) NSString *_Nullable reason;

- (instancetype)initWithText:(NSString *_Nullable)text
                        feedbackText:(NSString *_Nullable)feedbackText
                        type:(FeedbackConfigType)type
                      reason:(NSString *_Nullable)reason;
@end

NS_ASSUME_NONNULL_END
