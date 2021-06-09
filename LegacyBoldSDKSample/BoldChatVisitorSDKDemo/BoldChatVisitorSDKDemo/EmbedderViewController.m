//
//  EmbedderViewController.m
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import "EmbedderViewController.h"
#import <BoldEngineUI/BoldChatViewController.h>

@interface EmbedderViewController ()

@property(nonatomic, strong)UIButton *dismissButton;
@property(nonatomic, strong)UIButton *moverButton;
@property(nonatomic, assign)BOOL chatHidden;

@end

@implementation EmbedderViewController

@synthesize delegate = _delegate;
@synthesize chatViewController = _chatViewController;
@synthesize dismissButton = _dismissButton;
@synthesize moverButton = _moverButton;
@synthesize chatHidden = _chatHidden;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[UIDevice currentDevice].systemVersion floatValue] > 6.99) {
        self.dismissButton.frame = CGRectMake(0, 15, 80, 40);
    } else {
        self.dismissButton.frame = CGRectMake(0, 0, 80, 40);
    }
    self.dismissButton.autoresizingMask =  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.dismissButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.dismissButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.dismissButton setBackgroundColor:[UIColor clearColor]];
    self.dismissButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.dismissButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.dismissButton.userInteractionEnabled = YES;
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(dismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.dismissButton];
    
    self.moverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moverButton.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - M_PI / 2);
    self.moverButton.frame = CGRectMake(self.view.frame.size.width - 320 - 40,
                                        (self.view.frame.size.height - 200)/2,
                                        40, 200);
    
    [self.moverButton.titleLabel setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [self.moverButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.moverButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.moverButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    self.moverButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.moverButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.moverButton.userInteractionEnabled = YES;
    [self.moverButton setTitle:@"Hide" forState:UIControlStateNormal];
    [self.moverButton setTitle:@"Hide" forState:UIControlStateHighlighted];
    [self.moverButton setTitle:@"Show" forState:UIControlStateSelected];
    [self.moverButton setTitle:@"Show" forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.moverButton addTarget:self action:@selector(moverButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.moverButton];
    self.moverButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [self addChildViewController:self.chatViewController];
    self.chatViewController.view.frame = CGRectMake(self.view.frame.size.width - 320, 0, 320, self.view.frame.size.height);
    self.chatViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:self.chatViewController.view];
    [self.chatViewController didMoveToParentViewController:self];
    
    self.chatViewController.view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.chatViewController.view.layer.borderWidth = 1;
}

- (void)dismissButtonPressed:(UIButton *)button {
    [self.delegate embedderViewControllerNeedsDismiss:self];
}

- (void)moverButtonPressed:(UIButton *)button {
    if (self.chatHidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.chatViewController.view.frame = CGRectMake(self.chatViewController.view.frame.origin.x - 320,
                                                            self.chatViewController.view.frame.origin.y,
                                                            self.chatViewController.view.frame.size.width,
                                                            self.chatViewController.view.frame.size.height);
            self.moverButton.frame = CGRectMake(self.moverButton.frame.origin.x - 320,
                                                self.moverButton.frame.origin.y,
                                                self.moverButton.frame.size.width,
                                                self.moverButton.frame.size.height);
        } completion:^(BOOL finished) {
            self.chatHidden = NO;
            self.moverButton.selected = NO;
        }];
    } else {
        UINavigationController *chatHolderNavigationController = (UINavigationController *)self.chatViewController;
        BoldChatViewController *boldChatViewController = (BoldChatViewController *)chatHolderNavigationController.topViewController;
        [boldChatViewController resignContainedFirstResponder];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.chatViewController.view.frame = CGRectMake(self.chatViewController.view.frame.origin.x + 320,
                                                            self.chatViewController.view.frame.origin.y,
                                                            self.chatViewController.view.frame.size.width,
                                                            self.chatViewController.view.frame.size.height);
            self.moverButton.frame = CGRectMake(self.moverButton.frame.origin.x + 320,
                                                self.moverButton.frame.origin.y,
                                                self.moverButton.frame.size.width,
                                                self.moverButton.frame.size.height);
        } completion:^(BOOL finished) {
            self.chatHidden = YES;
            self.moverButton.selected = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
