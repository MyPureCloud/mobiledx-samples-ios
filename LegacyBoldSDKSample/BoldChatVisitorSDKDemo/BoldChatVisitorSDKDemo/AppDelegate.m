//
//  AppDelegate.m
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "InitialViewController.h"
#import "BCAccount+CurrentAccount.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navController = nil;
    InitialViewController *initialViewController = [[InitialViewController alloc] init];
    navController = [[UINavigationController alloc] initWithRootViewController:initialViewController];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [BCAccount setUpAccount:url];
    return YES;
}


@end
