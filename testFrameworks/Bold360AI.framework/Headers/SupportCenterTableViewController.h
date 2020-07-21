
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "SupportCenterBase.h"
#import "LabelDelegate.h"
#import "SupportCenterDataSource.h"
#import "NRResult.h"


NS_ASSUME_NONNULL_BEGIN

@protocol SupportCenterDelegate<NSObject>
- (void)didSelectResult:(NRQueryResult *)result;
- (void)clear;
@end

@interface SupportCenterTableViewController : UITableViewController <SupportCenterBase, LabelDelegate>
@property (nonatomic, weak) id<SupportCenterDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
