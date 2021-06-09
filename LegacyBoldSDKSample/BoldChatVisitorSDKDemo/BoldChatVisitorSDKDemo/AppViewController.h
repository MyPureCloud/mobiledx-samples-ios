//
//  AppViewController.h
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppViewController;

@protocol AppViewControllerDelegate <NSObject>

- (void)dismissAppViewController:(AppViewController *)appViewController;

@end

@interface AppViewController : UIViewController

@property(nonatomic, assign)id<AppViewControllerDelegate> delegate;

@end
