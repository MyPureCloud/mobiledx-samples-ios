
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "ChatHandler.h"
#import "ChatElementDelegate.h"
#import "LocalChatElement.h"
#import "SpeechReconitionDelegate.h"
#import "ChatConfiguration.h"
#import "ViewConfiguration.h"

/************************************************************/
// MARK: - ChatViewController
/************************************************************/

@interface ChatViewController : UIViewController<ChatHandlerDelegate>

@property (nonatomic, strong) id<ViewConfiguration> viewConfiguration;

/**
 `ChatHandler` used as Bot/ Handover handler
 */
@property (nonatomic, strong) id<ChatHandler> chatHandler;

/**
 `ChatEventHandler` object used to handle events on chat.
 */
@property (nonatomic, strong) id<ChatEventHandler> chatEventHandler;

/**
 `SpeechReconitionDelegate` object used to manage speech recognition status.
 */
@property (nonatomic, weak) id<SpeechReconitionDelegate> speechReconitionDelegate;

/**
 `ChatConfiguration` object used to manage speech recognition status.
 */
@property (nonatomic, strong) ChatConfiguration *config;

@end
