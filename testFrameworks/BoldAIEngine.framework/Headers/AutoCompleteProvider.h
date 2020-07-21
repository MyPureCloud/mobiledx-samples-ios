
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <BoldCore/Account.h>

/************************************************************/
// MARK: - AutoCompleteDeleagte
/************************************************************/

@protocol AutoCompleteDeleagte
@optional
- (void)onAutoCompleteReady;
- (void)didFailWithError:(NSError *_Nullable)error;
@end

/************************************************************/
// MARK: - AutoCompleteProvider
/************************************************************/

@protocol AutoCompleteProvider

/************************************************************/
// MARK: - Properties
/************************************************************/

@property (nullable, nonatomic, strong) Account *account;

/// Auto complete deleagte.
@property (nonatomic, weak) id<AutoCompleteDeleagte> _Nullable delegate;

/************************************************************/
// MARK: - Functions
/************************************************************/

/// Auto complete suggestions fetcher.
- (void)fetchSuggestionsForText:(NSString *_Nullable)text
                     completion:(void (^_Nullable)(NSArray * _Nullable suggestions))completion;

@end
