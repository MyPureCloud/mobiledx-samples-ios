//
//  OpenerViewController.m
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import "OpenerViewController.h"
#import <BoldEngineUI/BoldChatViewController.h>
#import <BoldEngineUI/BoldEngineUI.h>
#import "AppViewController.h"
#import "ChatStartedViewController.h"
#import "EmbedderViewController.h"

@interface OpenerViewController () <BCChatAvailabilityDelegate, AppViewControllerDelegate, EmbedderViewControllerDelegate, BoldChatViewControllerDelegate>

@property(nonatomic, strong)UIButton *button;
@property(nonatomic, strong)id<BCCancelable> cancelable;
@property(nonatomic, strong)BoldChatViewController *boldChatViewController;
@property(nonatomic, strong)UITabBarController *tabBarController;
@property(nonatomic, strong)EmbedderViewController *embedderViewController;
@property(nonatomic, assign)BOOL skipPreChat;
@property(nonatomic, strong)NSDictionary *extraParams;

- (BoldChatViewController *)createBoldChatViewController;
- (void)presentChatInModal;
- (void)presentChatInNavigation;
- (void)presentChatOnTab;
- (void)presentChatOnEmbeded;

@end

@implementation OpenerViewController

@synthesize type = _type;
@synthesize button = _button;
@synthesize account = _account;
@synthesize language = _language;
@synthesize cancelable = _cancelable;
@synthesize boldChatViewController = _boldChatViewController;
@synthesize tabBarController = _tabBarController;
@synthesize embedderViewController = _embedderViewController;
@synthesize skipPreChat = _skipPreChat;
@synthesize extraParams = _extraParams;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = ([[UIDevice currentDevice].systemVersion floatValue] > 6.99);
    self.title = @"Your App";
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.type == OpenerViewControllerTypeNavigationController) {
        self.button.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - M_PI / 2);
        self.button.frame = CGRectMake(self.view.frame.size.width - 33, 0, 33, self.view.frame.size.height);
        self.button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    } else {
        self.button.frame = CGRectMake(10, self.view.frame.size.height - 33, self.view.frame.size.width - 20, 33);
        self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }

    [self.button setTitle:@"Checking..." forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
    self.button.enabled = NO;
    self.button.userInteractionEnabled = YES;
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.cancelable = [self.account getChatAvailabilityWithDelegate:self];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    UIEdgeInsets safeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0) {
        safeInsets = self.view.safeAreaInsets;
    }
    
    if (self.type != OpenerViewControllerTypeNavigationController) {
        CGRect buttonFrame = self.button.frame;
        buttonFrame.origin.y = self.view.frame.size.height - buttonFrame.size.height - safeInsets.bottom;
        self.button.frame = buttonFrame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)buttonPressed:(UIButton *)button {
    [self.button setTitle:@"Show chat" forState:UIControlStateNormal];
    switch (self.type) {
        case OpenerViewControllerTypeModal:
            [self presentChatInModal];
            break;
            
        case OpenerViewControllerTypeNavigationController:
            [self presentChatInNavigation];
            break;
            
        case OpenerViewControllerTypeTabController:
            [self presentChatOnTab];
            break;
            
        case OpenerViewControllerTypeEmbeded:
            [self presentChatOnEmbeded];
            break;
            
        default:
            break;
    }
    [self.boldChatViewController start];
}

- (BoldChatViewController *)createBoldChatViewController {
    BoldChatAccountSettings *accountSettings = [[BoldChatAccountSettings alloc] init];
    accountSettings.account = self.account;
    NSString *visitorIdText = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"visitorId"];
    accountSettings.visitorId = visitorIdText;
    accountSettings.skipPreChat = self.skipPreChat;
//    accountSettings.extraParams = @{BCFormFieldCustomUrl : @"www.example.org"};
    
    BoldChatViewSettings *viewSettings = [[BoldChatViewSettings alloc] init];
    BoldChatViewController *boldChatViewController = [[BoldChatViewController alloc] initWithAccountSettings:accountSettings viewSettings:viewSettings language:self.language];
    boldChatViewController.delegate = self;
    return boldChatViewController;
}

- (void)presentChatInModal {
    if (!self.boldChatViewController) {
        self.boldChatViewController = [self createBoldChatViewController];
    }
    UINavigationController *navControllerWithBoldChat = [[UINavigationController alloc] initWithRootViewController:self.boldChatViewController];
    navControllerWithBoldChat.navigationBar.translucent = ([[UIDevice currentDevice].systemVersion floatValue] > 6.99);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStylePlain target:self action:@selector(hideModal)];
    self.boldChatViewController.navigationItem.leftBarButtonItem = rightBarButtonItem;
    self.boldChatViewController.navigationItem.leftBarButtonItem.enabled = YES;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        navControllerWithBoldChat.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:navControllerWithBoldChat animated:YES completion:nil];
    } else {
        [self presentViewController:navControllerWithBoldChat animated:YES completion:nil];
    }
}

- (void)presentChatInNavigation {
    if (!self.boldChatViewController) {
        self.boldChatViewController = [self createBoldChatViewController];
    }
    [self.navigationController pushViewController:self.boldChatViewController animated:YES];
}

- (void)presentChatOnTab {
    self.tabBarController = [[UITabBarController alloc] init];
    if ([self.tabBarController.tabBar respondsToSelector:@selector(setTranslucent:)]) {
        self.tabBarController.tabBar.translucent = ([[UIDevice currentDevice].systemVersion floatValue] > 6.99);
    }
    AppViewController *appViewController = [[AppViewController alloc] init];
    appViewController.delegate = self;
    UINavigationController *navigationControllerOfAppVC = [[UINavigationController alloc] initWithRootViewController:appViewController];
    navigationControllerOfAppVC.tabBarItem.title = @"Your App";
    navigationControllerOfAppVC.tabBarItem.image = [UIImage imageNamed:@"settings_icon"];
    navigationControllerOfAppVC.navigationBar.translucent = ([[UIDevice currentDevice].systemVersion floatValue] > 6.99);
    
    ChatStartedViewController *chatStartedVC = [[ChatStartedViewController alloc] init];
    UINavigationController *navigationControllerOfChat = [[UINavigationController alloc] initWithRootViewController:chatStartedVC];
    navigationControllerOfChat.tabBarItem.title = @"Chat";
    navigationControllerOfChat.tabBarItem.image = [UIImage imageNamed:@"tbChatBlue"];
    navigationControllerOfChat.navigationBar.translucent = ([[UIDevice currentDevice].systemVersion floatValue] > 6.99);
    
    if (!self.boldChatViewController) {
        self.boldChatViewController = [self createBoldChatViewController];
    }
    chatStartedVC.chatViewController = self.boldChatViewController;
    [navigationControllerOfChat pushViewController:self.boldChatViewController animated:YES];
    
    [self.tabBarController setViewControllers:@[navigationControllerOfAppVC, navigationControllerOfChat]];
    
    self.tabBarController.selectedIndex = 1;
    
    [self presentViewController:self.tabBarController animated:YES completion:nil];
}

- (void)presentChatOnEmbeded {
    if (!self.boldChatViewController) {
        self.boldChatViewController = [self createBoldChatViewController];
    }
    UINavigationController *navControllerWithBoldChat = [[UINavigationController alloc] initWithRootViewController:self.boldChatViewController];
    navControllerWithBoldChat.navigationBar.translucent = ([[UIDevice currentDevice].systemVersion floatValue] > 6.99);
    
    self.embedderViewController = [[EmbedderViewController alloc] init];
    self.embedderViewController.chatViewController = navControllerWithBoldChat;
    self.embedderViewController.delegate = self;
    
    [self presentViewController:self.embedderViewController animated:YES completion:nil];
}

- (void)hideModal {
    [self.boldChatViewController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark BCChatAvailabilityDelegate
- (void)bcChatAvailabilityChatAvailable:(id<BCCancelable>)cancelable {
    [self.button setTitle:@"Start chat" forState:UIControlStateNormal];
    self.button.enabled = YES;
    self.cancelable = nil;
}

//- (void)bcChatAvailability:(id<BCCancelable>)cancelable chatUnavailableForReason:(BCUnavailableReason)reason {
//    [self.button setTitle:@"Operator unavailable" forState:UIControlStateDisabled];
//    self.button.enabled = NO;
//    self.cancelable = nil;
//}

- (void)bcChatAvailability:(id<BCCancelable>)cancelable didFailWithError:(NSError *)error {
    [self.button setTitle:@"Operator unavailable" forState:UIControlStateDisabled];
    self.button.enabled = NO;
    self.cancelable = nil;
}

#pragma mark -
#pragma mark AppViewControllerDelegate
- (void)dismissAppViewController:(AppViewController *)appViewController {
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark EmbedderViewControllerDelegate
- (void)embedderViewControllerNeedsDismiss:(EmbedderViewController *)embedderViewController {
    [self.embedderViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark BoldChatViewControllerDelegate
- (void)boldChatViewControllerChatSessionDidStart:(BoldChatViewController *)boldChatViewController visitorId:(NSString *)visitorId language:(NSString *)language {
    [[NSUserDefaults standardUserDefaults] setValue:visitorId forKey:@"visitorId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
