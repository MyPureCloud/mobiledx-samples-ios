//
//  ChatStartedViewController.m
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import "ChatStartedViewController.h"

@interface ChatStartedViewController ()

@property(nonatomic, strong)UILabel *label;
@property(nonatomic, strong)UIButton *button;

@end

@implementation ChatStartedViewController

@synthesize chatViewController = _chatViewController;

@synthesize label = _label;
@synthesize button = _button;

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
    
    self.title = @"Chat Starter";
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, self.view.frame.size.width - 30, 78)];
    self.label.numberOfLines = 2;
    self.label.textColor = [UIColor darkGrayColor];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:17];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.label.text = @"Live Chat With our Operator.";
    [self.view addSubview:self.label];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    //self.button.frame = CGRectMake(10, self.view.frame.size.height - 33 - 40, self.view.frame.size.width - 20, 33);
    self.button.transform = CGAffineTransformRotate(CGAffineTransformIdentity, - M_PI / 2);
    self.button.frame = CGRectMake(self.view.frame.size.width - 33, 0, 33, self.view.frame.size.height);
    
    self.button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    [self.button setTitle:@"Show Chat" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
    self.button.userInteractionEnabled = YES;
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)buttonPressed:(UIButton *)button {
    [self.navigationController pushViewController:self.chatViewController animated:YES];
}


@end
