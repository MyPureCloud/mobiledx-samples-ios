
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "NRQuickOption.h"
#import "StorableChatElement.h"
#import "ApplicationHandler.h"
#import "ChatStateUnavailableEvent.h"
#import "BoldForm.h"
#import "BLDError.h"
#import "FileUploadInfo.h"

@protocol ChatControllerDelegate <ApplicationHandler>

@optional

/************************************************************/
// MARK: - Functions
/************************************************************/

- (void)shouldPresentChatViewController:(UINavigationController *)viewController;
- (void)statement:(id<StorableChatElement>)statement didFailWithError:(NSError *)error;
- (void)didClickApplicationQuickOption:(NRQuickOption *)quickOption;
- (BOOL)shouldPresentWelcomeMessage;
- (BOOL)shouldHandleFormPresentation:(UIViewController *)formController;

/**
 Updates when chat state was changed (chat lifecycle).
 */
- (void)didUpdateState:(ChatStateEvent *)event;

- (void)didClickToCall:(NSString *)phoneNumber;

/**
 Updates when chat was errored.
 */
- (void)didFailWithError:(BLDError *)error;

/**
 Triggred when form should be presented.
 
 @param form The form data object.
 @param completionHandler The handler with custome view controller to be presented.
 */
- (void)shouldPresentForm:(BrandedForm *)form handler:(void (^)(UIViewController<BoldForm> *vc))completionHandler;

/*
Notifies about upload file button click.

@param fileSelectionCallback The callback to be called once file was selected.
*/
- (void)didClickUploadFile;

@end
