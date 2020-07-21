
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol ApplicationHandler <NSObject>
@optional
- (void)didClickLink:(NSString *)url;
- (BOOL)presentingController:(UIViewController *)controller shouldHandleClickedLink:(NSString *)link;
@end

NS_ASSUME_NONNULL_END
