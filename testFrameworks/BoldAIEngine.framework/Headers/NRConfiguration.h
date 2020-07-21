
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FeedbackConfiguration.h"
#import "NRLabel.h"
#import "NRBaseResponse.h"
#import "ConversationSettings+InstantFeedback.h"

/************************************************************/
// MARK: - NRNavBarConfiguration
/************************************************************/


@interface NRNavBarConfiguration : NRComponentConfiguration
@property (nonatomic, copy) NSString *title;
@end

/************************************************************/
// MARK: - NRTitleConfiguration
/************************************************************/

@interface NRTitleConfiguration : NRComponentConfiguration
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic, copy) NSString *accessoryImageName;
@property (nonatomic) UIEdgeInsets resultInset;
@property (nonatomic) UIEdgeInsets textInset;
@end

/************************************************************/
// MARK: - NRSearchBarConfiguration
/************************************************************/

@interface NRSearchBarConfiguration : NRComponentConfiguration
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic) BOOL voiceEnabled;
@property (nonatomic) UISearchBarStyle searchBarStyle;
@end

/************************************************************/
// MARK: - NRAutoCompleteConfiguration
/************************************************************/

@interface NRAutoCompleteConfiguration : NRComponentConfiguration
@property (nonatomic) BOOL autocompleteEnabled;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) BOOL withDivider;
@property (nonatomic) UIFont *boldedFont;
@end

/************************************************************/
// MARK: - NRContentConfiguration
/************************************************************/

@interface NRContentConfiguration : NRComponentConfiguration

@end

/************************************************************/
// MARK: - NRChannelingConfiguration
/************************************************************/

@interface NRChannelingConfiguration : NRComponentConfiguration

@end

/************************************************************/
// MARK: - NRLogoConfiguration
/************************************************************/

@interface NRLogoConfiguration : NRComponentConfiguration
@property (nonatomic) BOOL hideBranding;
@end

/************************************************************/
// MARK: - FAQPresentationType
/************************************************************/

typedef NS_ENUM(NSInteger, FAQPresentationType) {
    FAQPresentationTypeBasic,
    FAQPresentationTypeLabels,
    FAQPresentationTypeSupportCenter
};

/************************************************************/
// MARK: - NRConfiguration
/************************************************************/

@interface NRConfiguration : NRBaseResponse

@property (nonatomic) UIColor *statusBarColor;
@property (nonatomic, readonly) NRNavBarConfiguration *navBar;
@property (nonatomic, readonly) NRTitleConfiguration *title;
@property (nonatomic, readonly) NRSearchBarConfiguration *searchBar;
@property (nonatomic, readonly) NRAutoCompleteConfiguration *autoComplete;
@property (nonatomic, readonly) NRContentConfiguration *content;
@property (nonatomic, readonly) NRLikeConfiguration *like;
@property (nonatomic, readonly) NRNegativeFeedbackConfiguration *negativeFeedback;
@property (nonatomic, readonly) InstantFeedbackConfiguration *instantFeedback;
@property (nonatomic, readonly) NRChannelingConfiguration *channeling;
@property (nonatomic, readonly) NRLogoConfiguration *logo;
@property (nonatomic, readonly) ConversationSettings *conversationSettings;

@property (nonatomic, readonly) BOOL isContextDependent;
@property (nonatomic, copy) NSArray<NRFAQGroup *> *faqs;
@property (nonatomic, copy) NSString *welcomeMessageId;
@property (nonatomic, strong) NRConversationalResponse *welcomeMessage;
@property (nonatomic, copy, readonly) NSString *languageCode;
@property (nonatomic, copy, readonly) NSString *kbId;
@property (nonatomic, copy, readonly) NSString *customNoAnswersText;
@property (nonatomic, copy, readonly) NSString *customNoAnswersTextContext;
@property (nonatomic, copy, readonly) NSString *feedbackCustomiseText;
@property (nonatomic, copy, readonly) NSArray<NRFAQGroup *> *labels;
@property (nonatomic) BOOL useLabels;
@property (nonatomic, assign) FAQPresentationType faqPresentationType;
@property (nonatomic, copy, readonly) NSString *eventTrackingSamplingLevel;
@end
