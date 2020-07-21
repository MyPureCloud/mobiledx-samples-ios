
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import <BoldAIEngine/BoldAIEngine.h>
#import "BaseViewController.h"

@protocol NRGroupsViewDelegate <NSObject>

- (void)didSelectGroup:(NRFAQGroup *)group;

@end

@interface NRGroupsView : UIView
@property (nonatomic, copy) NSArray<NRFAQGroup *> *groups;
@property (nonatomic, weak) id<NRGroupsViewDelegate> delegate;
@property (nonatomic, copy) NSString *noResultsText;
@property (nonatomic, copy) NSString *searchQuery;
- (void)updateIcon:(NSData *)icon atIndex:(NSInteger)index;
- (void)reset;
@property (nonatomic, readonly) BaseViewController *attachController;
@end
