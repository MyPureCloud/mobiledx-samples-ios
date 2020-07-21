
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "StorableChatElement.h"
#import "LocalChatElement.h"
#import "ChatEventHandler.h"
#import "ChatControllerDelegate.h"
#import "PreChatInfo.h"
#import <BoldCore/ContinuityProvider.h>
#import "ChatElementDelegate.h"
#import <BoldCore/UploadRequest.h>
#import <BoldCore/EventTracker.h>
#import <BoldCore/TrackingDatasource.h>
#import "ChatRecorder.h"
#import "TextToSpeechParser.h"
#import "ReadoutHandler.h"

typedef NS_ENUM(NSInteger, ChatEventType) {
    ChatEventReadmore,
    ChatEventChannel,
    ChatEventRefresh,
    ChatEventTyping,
    ChatEventEndTyping,
    ChatEventOperatorChanged,
    ChatEventStartQueue,
    ChatEventEndQueue,
    ChatEventFileUploadStateChanged,
    ChatEventFileUploadQueuePosition
};

@protocol ChatHandler;

/************************************************************/
// MARK: - ChatHandlerDelegate
/************************************************************/

@protocol ChatHandlerDelegate <NSObject>

/**
 Present Chat Element.

 @param statement Chat element that is going to be presented.
 */
- (void)presentStatement:(id<StorableChatElement> _Nonnull)statement;

/**
 Present Feedback Chat Element.

 @param statement Chat element that is going to be presented.
 */
- (void)presentFeedbackStatement:(id<StorableChatElement> _Nonnull)statement;

/**
Read text using TTS.

@param text text that is going to be read.
*/
- (void)readText:(NSString *_Nullable)text;

/**
 Update chat status (chat lifecycle)
 
 @param status chat status
 @param element chat element
 */
- (void)updateStatus:(StatementStatus)status element:(id<StorableChatElement> _Nonnull)element;

/**
 Event handler
 
 @param event event name
 @param params any params
 */
- (void)event:(ChatEventType)event withParams:(NSDictionary *_Nullable)params;

- (void)preChat:(PreChatInfo *_Nullable)preChatInfo;
- (void)postChat:(NSDictionary *_Nullable)postChatInfo;
- (void)reloadConfigurationForChatHandler:(id<ChatHandler>_Nonnull)chatHandler;
- (void)reloadAutoCompleteForChatHandler:(id<ChatHandler>_Nonnull)chatHandler;
@end

/************************************************************/
// MARK: - ChatHandlerProvider
/************************************************************/

@protocol ChatHandlerProvider <NSObject>
- (void)didEndChat:(id<ChatHandler> _Nullable)chatHandler;
- (void)presentForm:(BrandedForm *_Nullable)form;
- (ChatElementConfiguration *_Nonnull)configurationForType:(ChatElementType)type;
- (void)didCreateChat;
- (void)didStartChat;
- (void)didFailStartChatWithError:(NSError *_Nullable)error;

@optional
- (void)shouldReplaceChatHandler:(NSDictionary *_Nullable)chatHandlerParams;
@end

/************************************************************/
// MARK: - ChatHandler
/************************************************************/

@protocol ChatHandler <ChatEventHandler, TrackingDatasource>

/**
 The chat handler delegate.
 */
@property(nonatomic, weak) id<ChatHandlerDelegate> _Nullable delegate;

/**
 The chat controller delegate.
 */
@property(nonatomic, weak) id<ChatControllerDelegate> _Nullable chatControllerDelegate;

/**
 The chat handlet provider.
 */
@property(nonatomic, weak) id<ChatHandlerProvider> _Nullable chatHandlerProvider;

/**
 The chat readout handler.
 */
@property(nonatomic, weak) id<ReadoutHandler> _Nullable readoutHandler;

/**
 File upload feature indicator.
 */
@property(nonatomic, readonly) BOOL isFileTransferEnabled;

/**
  Auto complete feature indicator.
*/
@property(nonatomic, readonly) BOOL isAutocompleteEnabled;

/**
 Chat Bar indicator.
*/
@property (nonatomic, readonly) BOOL shouldPresentChatBar;

/**
 The trackingEventHandler
 */
@property(nonatomic, strong) id<EventTracker> _Nonnull tracker;

/**
  Text To Speech feature indicator.
*/
@property(nonatomic, readonly) BOOL isTextToSpeechEnabled;

/**
The Text To Speech Parser
*/
@property (strong, nonatomic) TextToSpeechParser * _Nullable textToSpeechParser;

/**
 Whole Brandind Dictionary
 */
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> * _Nullable branding;

/**
 Start chat implementation.
 */
- (void)startChat:(NSDictionary<NSString *, id> *_Nullable)chatHandlerParams;

/**
 End chat implementation.
 */
- (void)endChat;

/**
 Post chat element implementation.
 */
- (void)postStatement:(id<StorableChatElement> _Nonnull)statement;

/**
 Indicates if typing was started.
 */
- (void)didStartTyping:(BOOL)isTyping;

@optional

/**
 The history provider.
 */
@property(nonatomic, weak) id<ChatElementDelegate> _Nullable chatElementDelegate;

/**
 Does the upload process.
 */
- (void)uploadFile:(UploadRequest *_Nonnull)filePath
          progress:(void (^_Nullable)(float progress))progress
        completion:(void (^_Nonnull)(FileUploadInfo *_Nullable fileInfo))completion;

- (void)postTranscript:(NSString *_Nullable)transcript;

/**
 Form submission implementation.
 */
- (void)submitForm:(BrandedForm *_Nullable)form;

/**
 Post article implementation.
 */
- (void)postArticle:(LocalChatElement *_Nullable)article;

/**
 Chat element recorder, records the last bot conversation.
 */
@property(nonatomic, strong) ChatRecorder *_Nullable chatElementRecorder;

/**
 The current chat state.
 */
@property(nonatomic) ChatState currentChatState;

/**
 Should continue from last position (chat element).
 */
@property(nonatomic, weak) id<ContinuityProvider> _Nullable continuityProvider;
@end
