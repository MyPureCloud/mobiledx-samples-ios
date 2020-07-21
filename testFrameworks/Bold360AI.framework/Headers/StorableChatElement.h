
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "StatementScope.h"
#import "ChatElement.h"
#import "StatementStatus.h"

/************************************************************/
// MARK: - StorableChatElement
/************************************************************/

typedef NS_ENUM(NSInteger, FeedbackStatus) {
    FeedbackStatusLike = 0,
    FeedbackStatusDislike = 1,
    FeedbackStatusDefault = 2
};

@protocol StorableChatElement <ChatElement>

/************************************************************/
// MARK: - Properties
/************************************************************/

/**
 The chat elements converted to bytes
 */
@property (nonatomic, copy, readonly) NSString *storageKey;
/**
 The current agent type.
 */
@property (nonatomic, assign) StatementScope statementScope;
/**
 The current statement status.
 */
@property (nonatomic, assign) StatementStatus status;

@property (nonatomic, readonly) FeedbackStatus feedbackStatus;

@property (nonatomic, copy) NSNumber *articleId;
@end
