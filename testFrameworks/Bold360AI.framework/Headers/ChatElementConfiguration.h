
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "ChatViewConfiguration.h"

/************************************************************/
// MARK: - ChatElementConfiguration
/************************************************************/

typedef NS_ENUM(NSInteger, AvatarPosition) {
    AvatarPositionTopLeft = 0,
    AvatarPositionBottomLeft = 1,
    AvatarPositionTopRight = 2,
    AvatarPositionBottomRight = 3
};

@interface ChatElementConfiguration : ChatViewConfiguration

/**
 Chat Element Avatar
 */

@property (nonatomic) AvatarPosition avatarPosition;

@property (strong, nonatomic) UIImage *avatar;

@property (copy, nonatomic) UIColor *textColor;

@property (copy, nonatomic) NSDateFormatter *dateFormatter;

@property (copy, nonatomic) NSDateFormatter *timeFormatter;

@end
