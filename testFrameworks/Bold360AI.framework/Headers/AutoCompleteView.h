
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "SearchViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AutoCompleteViewDelegate <NSObject>

- (void)didPickSuggestion:(NSDictionary<NSString *,id<NSCopying>> *)suggestion;
- (void)updateHeightWithDiff:(CGFloat)heightDiff;

@end

@interface AutoCompleteView : UITableView
@property (nonatomic, copy)  NSArray<NSDictionary<NSString *,id<NSCopying>> *> * _Nullable suggestions;
@property (nonatomic, weak) id<AutoCompleteViewDelegate> _Nullable autoCompleteDelegate;
@property (nonatomic, strong) AutoCompleteConfiguration *configuration;
@end

NS_ASSUME_NONNULL_END
