
// NanorepUI version number: v3.8.6 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <BoldCore/Account.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AutoCompleteControllerDelegate <NSObject>

- (void)shouldPresentAutoCompleteViewController:(UIViewController *)controller;
- (void)controller:(UIViewController *)controller updateHeight:(CGFloat)height;
- (void)didPickSuggestion:(NSDictionary *)suggestion;

@end

@protocol AutoComplete <NSObject>
@property (nonatomic, readonly) Account *account;
@end

NS_ASSUME_NONNULL_END
