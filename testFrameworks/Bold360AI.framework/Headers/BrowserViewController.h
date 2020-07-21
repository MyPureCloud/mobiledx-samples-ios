
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol BrowserViewControllerDelgate
- (void)didSelectLinkedArticle:(NSString *)articleId;
@end

@interface BrowserViewController : BaseViewController
@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, weak) id<BrowserViewControllerDelgate> delegate;
@end
