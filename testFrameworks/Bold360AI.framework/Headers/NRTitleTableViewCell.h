
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "NRTableViewCell.h"
#import <BoldAIEngine/SupportCenterItem.h>

@class NRTitleTableViewCell;
@protocol NRTitleTableViewCellDelegate  <NSObject>

- (void)updatedDynamicHeight:(NRTitleTableViewCell *)cell;
- (void)didClickArrow:(NRTitleTableViewCell *)cell;

@end

@interface NRTitleTableViewCell : UITableViewCell
@property (nonatomic, strong) NRResult *result;
@property (nonatomic, strong) id<SupportCenterItem> item;
@property (nonatomic, copy) NSString *text;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (copy, nonatomic) UIImage *icon;
@property (nonatomic) NRAnimationType animationType;
@property (nonatomic, weak) id<NRTitleTableViewCellDelegate> delegate;
@end
