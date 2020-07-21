
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "InfoViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - ChatBarConfiguration
/************************************************************/

@interface ChatBarConfiguration : InfoViewConfiguration
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *agentName;
@property (copy, nonatomic) NSString *endChatBtnTitle;
@property (copy, nonatomic) UIColor *endChatBtnTextColor;
@property (assign, nonatomic) BOOL endChatButtonEnabled;
@property (assign, nonatomic) BOOL enabled;
@end

NS_ASSUME_NONNULL_END
