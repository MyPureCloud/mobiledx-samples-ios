
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import <BoldCore/ChatBarModel.h>
#import "ChatBarConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - ChatBarDelegate
/************************************************************/

@protocol ChatBarDelegate <NSObject>

- (void)didClickEndChat;

@end

/************************************************************/
// MARK: - ChatBarViewController
/************************************************************/

@interface ChatBarViewController : UIViewController
@property (nonatomic, strong) ChatBarModel *data;
@property (nonatomic, weak) id<ChatBarDelegate> delegate;

///  Chat Bar Configuration
@property (strong, nonatomic, readonly) ChatBarConfiguration *config;
@end

NS_ASSUME_NONNULL_END
