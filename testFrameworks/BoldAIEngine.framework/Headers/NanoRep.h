
// NanorepUI version number: v1.8.5 

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

extern NSString * _Nullable const NRAlertMessageKey;
extern NSString * _Nullable const NRAlertOKButtonKey;
extern NSString * _Nullable const NRAlertCancelButtonKey;

@protocol NRChatEngineDelegate <NSObject>
- (void)didFetchConvesationId:(NSString *_Nonnull)conversationId;
- (void)shouldHandleMissingEntities:(NRConversationalResponse *_Nonnull)response
             missingEntitiesHandler:(void(^_Nonnull)(NRConversationMissingEntity *_Nonnull  missingEntity))handler;
- (void)shouldHandlePersonalInformation:(NRPersonalInfo *_Nonnull)personalInfo;
@end


@protocol NanoRepDelegate <NSObject>
@optional
- (void)accountReady:(BotAccount *_Nonnull)account;
@end


/**
 This is the NanoRep core class providing NanoRep API requests.
 */

@interface NanoRep : NSObject


+ (NanoRep *_Nullable)shared;

- (void)prepareWithBotAccount:(BotAccount *_Nullable)botAccount;

@property (nonatomic, copy) void (^ _Nullable fetchConfiguration)(NRConfiguration * _Nullable configuration, NSError * _Nullable error);

@property (nonatomic, strong) BotAccount * _Nullable botAccount;

@property (nonatomic, strong, readonly) NRConfiguration * _Nullable configuration;

@property (nonatomic, strong, readonly) NRErrorHandler * _Nullable errorHandler;

@property (nonatomic, weak) id<NRChatEngineDelegate> _Nullable delegate;

@property (nonatomic, readonly) BOOL isPrepared;

@property (nonatomic, readonly) NRLikeStateHandler * _Nullable likeState;

@property (nonatomic, weak) id<NRChatEngineDelegate> _Nullable chatDelegate;

@property (nonatomic, strong) id<NRConnectionHandler> _Nullable connectionHandler;

- (void)fetchArticle:(NSString *_Nonnull)articleId completion:(void (^_Nonnull)(NRQueryResult *_Nullable, NSError *_Nullable))completion;

- (void)fetchAnswer:(NSArray<NSURLQueryItem *> *_Nonnull)items
                  hash:(NSNumber *_Nullable)hash
            completion:(void (^_Nonnull) (NRQueryResult * _Nullable result, NSError * _Nullable error))completion;


- (void)fetchConversationCNF:(void (^_Nonnull)(NRConfiguration * _Nullable configuration, NSError * _Nullable error))completion;


// Depends on cnf
- (void)createConversationWithEntities:(NSArray<NSString *> *_Nullable)entities
                              textOnly:(BOOL)textOnly
                            completion:(void(^_Nullable)(NSDictionary * _Nullable cnversationParams, NSError * _Nullable error))completion;

- (void)conversationWithEntities:(NSArray<NSString *> *_Nullable)entities
                        textOnly:(BOOL)textOnly
                      completion:(void(^_Nullable)(NSDictionary * _Nullable cnversationParams, NSError * _Nullable error))completion;


- (void)conversationStatement:(NSURLComponents *_Nonnull)componenets
                   completion:(void (^_Nonnull)(NRConversationalResponse * _Nullable response, NSError * _Nullable error))completion;

- (void)faqForLabel:(NRLabel *_Nullable)label
         completion:(void(^_Nullable)(NSArray<NRQueryResult *> * _Nullable results))completion;

- (void)searchText:(NSString *_Nullable)text
        completion:(void(^_Nullable)(NRSearchResponse * _Nullable searchResponse, NSError * _Nullable error))completion;

- (void)contextValue:(NSString *_Nullable)contexts
          completion:(void(^_Nullable)(NSDictionary * _Nullable values, NSError * _Nullable error))completion;

- (void)changeContext:(NSDictionary<NSString *, NSString *> *_Nullable)context
           completion:(void(^_Nullable)(BOOL success, NSError * _Nullable error))completion;

- (void)suggestionsForText:(NSString *_Nullable)text
            isConversation:(BOOL)isConversation
                completion:(void(^_Nullable)(NRAutoCompleteResponse * _Nullable response, NSError * _Nullable error))completion;

- (void)channels:(NRQueryResult *_Nonnull)result
         context:(NSString *_Nullable)context
      completion:(void(^_Nullable)(NSArray<NRChanneling *> * _Nullable channels, NSError * _Nullable error))completion;

- (void)channels:(NRQueryResult *_Nonnull)result
      completion:(void (^_Nullable)(NSArray<NRConversationQuickOption *> * _Nullable quickOptions, NSError * _Nullable error))completion;

- (void)like:(int)likeType
   forResult:(NRQueryResult *_Nullable)result
  completion:(void(^_Nullable)(NSString * _Nullable resultId, int type, BOOL success))completion;

/**
 * The api request that should be called for when user passes InstantFeedback value.
 */
- (void)postFeedbackWithArticleId:(NSString *_Nonnull)articleId
                   feedbackItem:(FeedbackItem *_Nullable)item
                       completion:(void(^_Nullable)(NSString * _Nullable resultId, int type, BOOL success))completion;

- (void)trackEvent:(NSDictionary *_Nullable)eventParams;

- (void)sendConversationFeedbackWithCompletion:(void(^_Nullable)(NRConversationalResponse * _Nullable respons))completion;

- (void)reportChanneling:(NRChanneling *_Nullable)channel article:(NRQueryResult *_Nullable)result;

- (void)stop;

@end
