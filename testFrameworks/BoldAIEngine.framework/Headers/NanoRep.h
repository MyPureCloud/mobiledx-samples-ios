
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "NRConfiguration.h"
#import "BotAccount.h"
#import "NRErrorHandler.h"
#import "NRSearchResponse.h"
#import "NRAutoCompleteResponse.h"
#import "NRConversationalResponse.h"
#import "NRLikeStateHandler.h"
#import <BoldCore/NRConnectionHandler.h>
#import "FeedbackItem.h"

extern NSString *const NRAlertMessageKey;
extern NSString *const NRAlertOKButtonKey;
extern NSString *const NRAlertCancelButtonKey;

@protocol NanoRepDelegate <NSObject>

@optional
- (void)accountReady:(BotAccount *)account;
@end


@protocol NRChatEngineDelegate <NSObject>
- (void)didFetchConvesationId:(NSString *)conversationId;
- (void)shouldHandleMissingEntities:(NRConversationalResponse *)response
             missingEntitiesHandler:(void(^)(NRConversationMissingEntity *missingEntity))handler;
- (void)shouldHandlePersonalInformation:(NRPersonalInfo *)personalInfo;

@end



/**
 This is the NanoRep core class providing NanoRep API requests.
 */

@interface NanoRep : NSObject


+ (NanoRep *)shared;

- (void)prepareWithBotAccount:(BotAccount *)botAccount;

@property (nonatomic, copy) void (^fetchConfiguration)(NRConfiguration *configuration, NSError *error);

@property (nonatomic, strong) BotAccount *botAccount;

@property (nonatomic, strong, readonly) NRConfiguration *configuration;

@property (nonatomic, strong, readonly) NRErrorHandler *errorHandler;

@property (nonatomic, weak) id<NRChatEngineDelegate> delegate;

@property (nonatomic, readonly) BOOL isPrepared;

@property (nonatomic, readonly) NRLikeStateHandler *likeState;

@property (nonatomic, weak) id<NRChatEngineDelegate> chatDelegate;

@property (nonatomic, strong) id<NRConnectionHandler> connectionHandler;

- (void)fetchFAQAnswer:(NSString *)answerId
                  hash:(NSNumber *)hash
            completion:(void (^) (NRQueryResult *result, NSError *error))completion;

- (void)fetchConversationCNF:(void (^)(NRConfiguration *configuration, NSError *error))completion;


// Depends on cnf
- (void)createConversationWithEntities:(NSArray<NSString *> *)entities
                              textOnly:(BOOL)textOnly
                            completion:(void(^)(NSDictionary *cnversationParams, NSError *error))completion;

- (void)conversationWithEntities:(NSArray<NSString *> *)entities
                        textOnly:(BOOL)textOnly
                      completion:(void(^)(NSDictionary *cnversationParams, NSError *error))completion;

- (void)conversationStatement:(NSString *)statement
                         type:(BOOL)isPostback
               conversationId:(NSString *)conversationId
                          src:(NSString *)src
                   completion:(void(^)(NRConversationalResponse *response, NSError *error))completion;

- (void)conversationArticle:(NSString *)articleId
             conversationId:(NSString *)conversationId
                  statement:(NSString *)statement
                        src:(NSString *)src
                 completion:(void (^)(NRConversationalResponse *, NSError *))completion;

- (void)faqForLabel:(NRLabel *)label
         completion:(void(^)(NSArray<NRQueryResult *> *results))completion;

- (void)searchText:(NSString *)text
        completion:(void(^)(NRSearchResponse *searchResponse, NSError *error))completion;

- (void)contextValue:(NSString *)contexts
          completion:(void(^)(NSDictionary *values, NSError *error))completion;

- (void)changeContext:(NSDictionary<NSString *, NSString *> *)context
           completion:(void(^)(BOOL success, NSError *error))completion;

- (void)suggestionsForText:(NSString *)text
            isConversation:(BOOL)isConversation
                completion:(void(^)(NRAutoCompleteResponse *response, NSError *error))completion;

- (void)channels:(NRQueryResult *_Nonnull)result
         context:(NSString *_Nullable)context
      completion:(void(^_Nullable)(NSArray<NRChanneling *> * _Nullable channels, NSError * _Nullable error))completion;

- (void)channels:(NRQueryResult *_Nonnull)result
      completion:(void (^_Nullable)(NSArray<NRConversationQuickOption *> * _Nullable quickOptions, NSError * _Nullable error))completion;

- (void)like:(int)likeType
   forResult:(NRQueryResult *)result
  completion:(void(^)(NSString *resultId, int type, BOOL success))completion;

/**
 * The api request that should be called for when user passes InstantFeedback value.
 */
- (void)postFeedbackWithArticleId:(NSString *_Nonnull)articleId
                   feedbackItem:(FeedbackItem *_Nullable)item
                       completion:(void(^_Nullable)(NSString * _Nullable resultId, int type, BOOL success))completion;

- (void)trackEvent:(NSDictionary *)eventParams;

- (void)sendConversationFeedbackWithCompletion:(void(^)(NRConversationalResponse *respons))completion;

- (void)reportChanneling:(NRChanneling *)channel article:(NRQueryResult *)result;

- (void)stop;

@end
