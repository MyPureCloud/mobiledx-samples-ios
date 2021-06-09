//
//  EmbedderViewController.h
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmbedderViewController;

@protocol EmbedderViewControllerDelegate <NSObject>

- (void)embedderViewControllerNeedsDismiss:(EmbedderViewController *)embedderViewController;

@end

@interface EmbedderViewController : UIViewController

@property(nonatomic, assign)id<EmbedderViewControllerDelegate> delegate;
@property(nonatomic, strong)UIViewController *chatViewController;

@end
