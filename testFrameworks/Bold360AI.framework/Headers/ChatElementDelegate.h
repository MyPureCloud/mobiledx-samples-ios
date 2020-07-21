
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "StorableChatElement.h"

@protocol ChatElementDelegate<NSObject>

/************************************************************/
// MARK: - Functions
/************************************************************/

/**
Store Chat Element

@param item Represents StorableChatItem
*/
- (void)didReceiveChatElement:(id<StorableChatElement>)item;

@optional

/**
Fetches StorableChatElement Array

@param from The index of chat item (e.g 0), paging supported
@param handler Fetch callback that gets StorableChatItem array
*/
- (void)fetch:(NSInteger)from handler:(void(^)(NSArray<id<StorableChatElement>> *elements))handler;

/**
 Remove Chat Element
 
 @param timestampId Identifier that used to remove StorableChatItem
 */
- (void)didRemoveChatElement:(NSTimeInterval)timestampId;

/**
 Update Chat Element
 
 @param timestampId The timestamp of chat element
 @param newTimestamp New timestamp for updated chat element
 @param status The status of chat element
 */
- (void)didUpdateChatElement:(NSTimeInterval)timestampId
                newTimestamp:(NSTimeInterval)newTimestamp
                      status:(StatementStatus)status;

- (void)didUpdateFeedback:(NSString *)articleId feedbackState:(FeedbackStatus)feedbackState;
@end
