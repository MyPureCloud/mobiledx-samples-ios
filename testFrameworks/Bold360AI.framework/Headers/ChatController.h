
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "ChatControllerDelegate.h"
#import "NREntitiesProvider.h"
#import "ChatElementDelegate.h"
#import <BoldCore/ContinuityProvider.h>
#import "ChatHandler.h"
#import "SpeechReconitionDelegate.h"
#import "ChatConfiguration.h"
#import "BoldEvent.h"
#import <Bold360AI/ViewConfiguration.h>
#import "AccountProvider.h"
#import "AvailabilityResult.h"
#import "HandOver.h"
#import "ProactiveChatElementHandler.h"

/************************************************************/
// MARK: - ChatController
/************************************************************/

@interface ChatController : NSObject

/************************************************************/
// MARK: - Properties
/************************************************************/

@property (nonatomic, strong) id<ViewConfiguration> _Nullable viewConfigurationSource;

/**
 The Entities Provider Handles Users Private Information.
 */
@property (nonatomic, weak) id<NREntitiesProvider> _Nullable entitiesProvider;

/**
 The History Provider For Controlling Chat History.
 */
@property (nonatomic, weak) id<ChatElementDelegate> _Nullable chatElementDelegate;

/**
 The Account Provider For fetching Account parameters.
 */
@property (nonatomic, weak) id<AccountProvider> _Nullable accountProvider;

/**
 The Continuity Provider For Stor/ Fetch of Chat Continuity Credentials.
 */
@property (nonatomic, weak) id<ContinuityProvider> _Nullable continuityProvider;

/**
 The Live Chat Handler (Not Bold, 3rd party lib)
 */
@property (nonatomic, strong) HandOver * _Nullable handOver;

/**
 The Chat View Configuration.
 */
@property (nonatomic, strong) ChatConfiguration * _Nonnull viewConfiguration;

/**
 File upload feature indicator.
 */
@property (nonatomic, readonly) BOOL isFileTransferEnabled;

/**
Hendles chat element injection.
*/
@property (nonatomic, strong, readonly) ProactiveChatElementHandler * _Nonnull proactiveChatElementHandler;

/************************************************************/
// MARK: - Delegates
/************************************************************/

/**
 Chat Controller Delegate
 */
@property (nonatomic, weak) id<ChatControllerDelegate> _Nullable delegate;

/**
 Speech Reconition Delegate
 */
@property (nonatomic, weak) id<SpeechReconitionDelegate> _Nullable speechReconitionDelegate;

/**
 Readout Handler
 */
@property (nonatomic, weak) id<ReadoutHandler> _Nullable readoutHandler;

/************************************************************/
// MARK: - Initializer
/************************************************************/

- (instancetype _Nonnull )initWithAccount:(Account *_Nonnull)account;

/************************************************************/
// MARK: - Functions
/************************************************************/

/**
 Helps to resend elements that faild.

 @param elements The Element to Resend.
 */
- (void)repostStatements:(NSArray<StorableChatElement> *_Nullable)elements;

/**
 Restores chat view controller.
 Should be implimented with history.
 */
- (void)restoreChatViewController;

/**
 Handle bold events.
 */
- (void)handleEvent:(BoldEvent *_Nonnull)event;

/**
 Ends current chat handler.
 */
- (void)endChat;

/**
 Teminates the chat controller and all active chats.
 */
- (void)terminate;

/**
 File Uploader.
 */
- (void)uploadFile:(UploadRequest *_Nonnull)request
          progress:(void (^_Nonnull)(float progress))progress
        completion:(void(^_Nonnull)(FileUploadInfo * _Nonnull fileInfo))completion;

/**
 The availability of the chat.
 */
+ (void)checkAvailability:(Account *_Nonnull)account
               completion:(void(^_Nonnull)(AvailabilityResult * _Nonnull result))completion;

/**
 The list of departments under account.
 */
+ (void)fetchDepartments:(Account *_Nonnull)account
              completion:(void(^_Nonnull)(DepartmentResult * _Nonnull result))completion;

@end
