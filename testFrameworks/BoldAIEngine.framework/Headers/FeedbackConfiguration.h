
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import "NRComponentConfiguration.h"

/************************************************************/
// MARK: - Feedback Types
/************************************************************/

typedef NS_ENUM(NSInteger, FeedbackType) {
    FeedbackTypeIcons,
    FeedbackTypeText
};

typedef NS_ENUM(NSInteger, NegativeFeedbackType) {
    NegativeFeedbackTypeBoth,
    NegativeFeedbackTypeMultipleChoices,
    NegativeFeedbackTypeFreeText
};

/************************************************************/
// MARK: - NRLikeConfiguration
/************************************************************/

@interface NRLikeConfiguration : NRComponentConfiguration
@property (nonatomic) BOOL shouldPresentDislikeOptions;
@property (nonatomic) FeedbackType feedbackType;
@property (nonatomic, copy) NSString * _Nullable feedbackPositiveButtonText;
@property (nonatomic, copy) NSString * _Nullable feedbackNegativeButtonText;
@property (nonatomic, copy) NSString * _Nullable feedbackCustomiseText;
@property (nonatomic, copy) NSString * _Nullable feedbackNegativeIcon;
@property (nonatomic, copy) NSString * _Nullable feedbackPositiveIcon;
@end

/************************************************************/
// MARK: - NRNegativeFeedbackConfiguration
/************************************************************/

@interface NRNegativeFeedbackConfiguration: NRComponentConfiguration
@property (nonatomic, copy) NSString * _Nullable inAccurateContent;
@property (nonatomic, copy) NSString * _Nullable notRelevantContent;
@property (nonatomic) NegativeFeedbackType type;
@property (nonatomic, copy) NSString * _Nullable placeholder;
@property (nonatomic, copy) NSString * _Nullable submitButtonText;
@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, copy) NSString * _Nullable disclaimer;
@end

/************************************************************/
// MARK: - InstantFeedbackConfiguration
/************************************************************/

@interface InstantFeedbackConfiguration : NRComponentConfiguration
/// Instant Feedback General Reply Text
@property (nonatomic, copy) NSString * _Nullable received;
/// Instant Feedback Provide Feedback Button Text
@property (nonatomic, copy) NSString * _Nullable actionButton;
/// Instant Feedback Provide Feedback Repeat Button Text
@property (nonatomic, copy) NSString * _Nullable actionRepeatButton;
/// Instant Feedback Inaccurate Button Text
@property (nonatomic, copy) NSString * _Nullable missingOrIncorrectInfo;
/// Instant Feedback Irrelevant Button Text
@property (nonatomic, copy) NSString * _Nullable incorrectSearchResult;
/// Instant Feedback Textual Feedback Request Text
@property (nonatomic, copy) NSString * _Nullable actionPrompt;
/// Instant Feedback Textual Feedback Repeat Request Text
@property (nonatomic, copy) NSString * _Nullable actionClarify;
/// Instant Feedback Dialog Title
@property (nonatomic, copy) NSString *_Nullable dialogTitle;

@property (nonatomic, readonly) NRLikeConfiguration * _Nullable likeConfiguration;
@end
