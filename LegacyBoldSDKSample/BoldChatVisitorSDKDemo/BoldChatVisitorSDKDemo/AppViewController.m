//
//  AppViewController.m
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import "AppViewController.h"

@interface AppViewController ()

@property(nonatomic, strong)UILabel *label;
@property(nonatomic, strong)UIButton *button;

@end

@implementation AppViewController

@synthesize delegate = _delegate;
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
    
    self.title = @"Your App";
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 54, self.view.frame.size.width - 30, 78)];
    self.label.numberOfLines = 2;
    self.label.textColor = [UIColor darkGrayColor];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:17];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.label.text = @"This is a tab of your application.";
    [self.view addSubview:self.label];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(15, self.view.frame.size.height - 33 - 50, self.view.frame.size.width - 30, 33);
    self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.button setTitle:@"Back to Samples" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
    self.button.userInteractionEnabled = YES;
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed:(UIButton *)button {
    [self.delegate dismissAppViewController:self];
}

@end
