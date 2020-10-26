
// NanorepUI version number: v3.8.7. 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "ChatViewConfiguration.h"

/************************************************************/
// MARK: - ChatElementConfiguration
/************************************************************/

typedef struct Corners {
    int left, right;
} Corners;

typedef struct BorderRadius {
    Corners top, bottom;
} BorderRadius;

typedef NS_ENUM(NSInteger, AvatarPosition) {
    AvatarPositionTopLeft = 0,
    AvatarPositionBottomLeft = 1,
    AvatarPositionTopRight = 2,
    AvatarPositionBottomRight = 3
};

@interface ChatElementConfigurationParent : ChatViewConfiguration

@property (nonatomic) Corners cornersBorderRadius;

@property (copy, nonatomic) UIColor *textColor;

@end

@interface ChatElementConfiguration : ChatElementConfigurationParent

/**
 Chat Element Avatar
 */

@property (nonatomic) AvatarPosition avatarPosition;

@property (copy, nonatomic) NSDateFormatter *dateFormatter;

@property (copy, nonatomic) NSDateFormatter *timeFormatter;

@property (strong, nonatomic) UIImage *avatar;

@property (nonatomic) BorderRadius borderRadius;


@end
