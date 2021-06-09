//
//  OpenerViewController.h
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BoldEngineUI/BoldChatViewController.h>

/** @file */
typedef enum {
    OpenerViewControllerTypeModal,
    OpenerViewControllerTypeNavigationController,
    OpenerViewControllerTypeTabController,
    OpenerViewControllerTypeEmbeded
}OpenerViewControllerType;

@interface OpenerViewController : UIViewController

@property(nonatomic, assign)OpenerViewControllerType type;
@property(nonatomic, strong)BCAccount *account;
@property(nonatomic, strong)NSString *language;

@end
