
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import <BoldAIEngine/NRConversationalResponse.h>
#import "SearchView.h"
#import "AutoCompleteView.h"
#import <BoldCore/Account.h>
#import "TrackingUsageConstants.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AutoCompletePickDelegate <NSObject>
@optional
- (void)didSelectSuggestion:(NSString *)articleId query:(NSString *)query;
- (void)didFetchArticle:(NRConversationalResponse *)article;
- (void)didFailToFetchAnArticleWithError:(NSError *)error;

@end

@interface SearchViewController : UIViewController <SearchViewDelegate>


- (void)reset;
- (void)softReset;

@property (nonatomic, strong) Account *account;
@property (nonatomic, weak) id<SearchViewControllerDelegate> delegate;

// If the app is implementing this protocol it will get the article.
@property (nonatomic, weak) id<AutoCompletePickDelegate> articlePickDelegate;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (nonatomic, assign) BOOL autoCompleteOnTop;
@property (nonatomic, weak) IBOutlet SearchView *searchView;
@property (nonatomic, strong) SearchViewConfiguration *configuration;
@property (nonatomic, weak) IBOutlet AutoCompleteView *autoCompleteView;
@end

NS_ASSUME_NONNULL_END
