//
//  InitialViewController.m
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import "InitialViewController.h"
#import <BoldEngineUI/BoldChatViewController.h>
#import "OpenerViewController.h"
#import "BCAccount+CurrentAccount.h"

@interface InitialViewController ()

@property(nonatomic, strong)UIButton *modalButton;
@property(nonatomic, strong)UIButton *navigationControllerButton;
@property(nonatomic, strong)UIButton *tabControllerButton;
@property(nonatomic, strong)UIButton *embededButton;
@property(nonatomic, strong)UIButton *resetVisitorIdButton;
@property(nonatomic, strong)UILabel *visitorIdLabel;

@property(nonatomic,strong)UINavigationController *navControllerWithBoldChat;
@property(nonatomic,strong)BoldChatViewController *boldChatViewController;

@property(nonatomic, strong)BCAccount *account;
@property(nonatomic, strong)NSString *language;

- (UIButton *)newSetUpButton;
- (void)presentOpenerViewWithType:(OpenerViewControllerType)type;

@end

@implementation InitialViewController

@synthesize modalButton = _modalButton;
@synthesize navigationControllerButton = _navigationControllerButton;
@synthesize tabControllerButton = _tabControllerButton;
@synthesize account = _account;
@synthesize embededButton = _embededButton;
@synthesize resetVisitorIdButton = _resetVisitorIdButton;
@synthesize visitorIdLabel = _visitorIdLabel;

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
    
    self.title = @"Samples";
    self.modalButton = [self newSetUpButton];
    self.modalButton.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, 33);
    [self.modalButton setTitle:@"Modal" forState:UIControlStateNormal];
    [self.modalButton addTarget:self action:@selector(modalButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.modalButton];
    
    self.navigationControllerButton = [self newSetUpButton];
    self.navigationControllerButton.frame = CGRectMake(10, 140, self.view.frame.size.width - 20, 33);
    [self.navigationControllerButton setTitle:@"Navigation View Controller" forState:UIControlStateNormal];
    [self.navigationControllerButton addTarget:self action:@selector(navButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.navigationControllerButton];
    
    self.tabControllerButton = [self newSetUpButton];
    self.tabControllerButton.frame = CGRectMake(10, 180, self.view.frame.size.width - 20, 33);
    [self.tabControllerButton setTitle:@"Tab View Controller" forState:UIControlStateNormal];
    [self.tabControllerButton addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tabControllerButton];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        self.embededButton = [self newSetUpButton];
        self.embededButton.frame = CGRectMake(10, 220, self.view.frame.size.width - 20, 33);
        [self.embededButton setTitle:@"Embeded View Controller" forState:UIControlStateNormal];
        [self.embededButton addTarget:self action:@selector(embededButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.embededButton];
    
    }
    
    self.visitorIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 66, self.view.frame.size.width - 20, 33)];
    self.visitorIdLabel.numberOfLines = 1;
    self.visitorIdLabel.textColor = [UIColor darkGrayColor];
    self.visitorIdLabel.backgroundColor = [UIColor clearColor];
    self.visitorIdLabel.textAlignment = NSTextAlignmentCenter;
    self.visitorIdLabel.font = [UIFont systemFontOfSize:17];
    self.visitorIdLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSString *visitorIdText = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"visitorId"];
    self.visitorIdLabel.text = [NSString stringWithFormat:@"Visitor ID: %@",visitorIdText ? visitorIdText : @"0"];
    [self.view addSubview:self.visitorIdLabel];
    
    self.resetVisitorIdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.resetVisitorIdButton.frame = CGRectMake(10, self.view.frame.size.height - 33, self.view.frame.size.width - 20, 33);
    self.resetVisitorIdButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.resetVisitorIdButton setTitle:@"Reset Visitor ID" forState:UIControlStateNormal];
    [self.resetVisitorIdButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.resetVisitorIdButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.resetVisitorIdButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.resetVisitorIdButton.enabled = YES;
    self.resetVisitorIdButton.userInteractionEnabled = YES;
    [self.resetVisitorIdButton addTarget:self action:@selector(resetVisitorIdPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resetVisitorIdButton];
    
    self.account = [BCAccount currentAccount];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *visitorIdText = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"visitorId"];
    self.visitorIdLabel.text = [NSString stringWithFormat:@"Visitor ID: %@",visitorIdText ? visitorIdText : @"0"];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    UIEdgeInsets safeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        safeInsets = self.view.safeAreaInsets;
    }
    
    CGRect resetFrame = self.resetVisitorIdButton.frame;
    resetFrame.origin.y = self.view.frame.size.height - resetFrame.size.height - safeInsets.bottom;
    self.resetVisitorIdButton.frame = resetFrame;
    
    CGRect visitorIdFrame = self.visitorIdLabel.frame;
    visitorIdFrame.origin.y = self.view.frame.size.height - visitorIdFrame.size.height - resetFrame.size.height - safeInsets.bottom;
    self.visitorIdLabel.frame = visitorIdFrame;
}

- (UIButton *)newSetUpButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.enabled = YES;
    button.userInteractionEnabled = YES;
    return button;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)modalButtonPressed:(UIButton *)button {
    [self presentOpenerViewWithType:OpenerViewControllerTypeModal];
}

- (void)navButtonPressed:(UIButton *)button {
    [self presentOpenerViewWithType:OpenerViewControllerTypeNavigationController];
}

- (void)tabButtonPressed:(UIButton *)button {
    [self presentOpenerViewWithType:OpenerViewControllerTypeTabController];
}

- (void)embededButtonPressed:(UIButton *)button {
    [self presentOpenerViewWithType:OpenerViewControllerTypeEmbeded];
}

- (void)resetVisitorIdPressed:(UIButton *)button {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"visitorId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.visitorIdLabel.text = @"Visitor ID: 0";
}

- (void)presentOpenerViewWithType:(OpenerViewControllerType)type {
    OpenerViewController *opener = [[OpenerViewController alloc] init];
    opener.type = type;
    opener.account = self.account;
    opener.language = self.language;
    
    [self.navigationController pushViewController:opener animated:YES];
}

@end
