
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>

@protocol NRAutoCompleteViewDelegate <NSObject>

- (void)searchText:(NSString *)text;

@end

@interface NRAutoCompleteView : UIView
@property (nonatomic, copy) NSArray<NSAttributedString *> *suggestions;
@property (nonatomic, weak) id<NRAutoCompleteViewDelegate> delegate;
@end
