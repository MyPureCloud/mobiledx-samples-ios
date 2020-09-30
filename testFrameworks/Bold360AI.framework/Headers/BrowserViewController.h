
// NanorepUI version number: v3.8.5 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol BrowserViewControllerDelgate
- (void)didSelectLinkedArticle:(NSArray<NSURLQueryItem *> *)components;
@end

@interface BrowserViewController : BaseViewController
@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, weak) id<BrowserViewControllerDelgate> delegate;
@end
