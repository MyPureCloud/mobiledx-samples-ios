
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - ChatTextViewDelegate
/************************************************************/

@protocol ChatTextViewDelegate <NSObject>
- (void)didStartTyping:(BOOL)isTyping;
@end

/************************************************************/
// MARK: - ChatTextView
/************************************************************/

@interface ChatTextView : UITextView
@property (nonatomic, weak) id<ChatTextViewDelegate> typingIndicationDelegate;
@end

NS_ASSUME_NONNULL_END
