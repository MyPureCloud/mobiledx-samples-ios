
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

@interface ChatBarModel : NSObject

/**
 * @brief The name of the operator to be displayed.
 */
@property(nonatomic, copy) NSString *name;

/**
 * @brief The image URL of the operator.
 */
@property(nonatomic, copy) NSString *imageUrl;

/**
 * @brief The end chat button title.
 */
@property(nonatomic, copy) NSString *endChatBtnTitle;

@end
