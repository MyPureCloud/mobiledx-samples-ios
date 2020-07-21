
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "StorableChatElement.h"
#import <BoldCore/NSString+Utilities.h>

/************************************************************/
// MARK: - ContentChatElement
/************************************************************/

extern NSString *const ChatElementDesignBotIncoming;
extern NSString *const ChatElementDesignBotOutgoing;
extern NSString *const ChatElementDesignSystem;
extern NSString *const ChatElementDesignCustomIncoming;
extern NSString *const ChatElementDesignCustomOutgoing;


/**
 A ContentChatElement is a wrapper used to define the type of chat (local, remote)
 */
@interface ContentChatElement : NSObject <StorableChatElement>
@property (nonatomic, copy) NSNumber *articleId;

// Enable set internally (replace readonly with readwrite)
@property (nonatomic, copy) NSString *design;
@property (nonatomic, copy) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) NSDateFormatter *timeFormatter;
@property (nonatomic, readonly) NSDictionary *highValueChatChannel;

- (instancetype)initWithType:(ChatElementType)type content:(NSString*)content;

@end
