
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "ApplicationHandler.h"
#import "NanorepPersonalInfoHandler.h"
#import "BaseViewController.h"
#import "ReadMoreViewConfiguration.h"
#import "NRResult.h"
#import "ChannelPickerDelegate.h"

@class NRReadMoreViewController;
@protocol NRReadMoreViewControllerDelegate<NSObject>
- (void)readmoreController:(NRReadMoreViewController *)readmoreController presentModally:(UIViewController *)controller;
- (void)readmoreController:(NRReadMoreViewController *)readmoreController shouldPresentMessage:(NSString *)message;
@optional
- (void)readmoreController:(NRReadMoreViewController *)readmoreController updateChannels:(NRResult *)result;
@end


@interface NRReadMoreViewController : BaseViewController
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, weak) id<ApplicationHandler> applicationHandler;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic) NRResult *result;
@property (nonatomic, weak) id<NanorepPersonalInfoHandler> infoHandler;
@property (nonatomic, weak) id<NRReadMoreViewControllerDelegate> delegate;
@property (nonatomic, strong) id<ChannelPickerDelegate> channelPickerDelegate;
@property (strong, nonatomic) ReadMoreViewConfiguration *config;
@property (nonatomic, assign) BOOL withFeedback;
- (void)setChannels:(NSArray<NRChanneling *> *)channels;
- (void)dismiss;
@end
