
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <WebKit/WebKit.h>
#import "ChatEventHandler.h"
#import "ContentChatElement.h"
#import "ChatConfiguration.h"

/************************************************************/
// MARK: - NRChatViewDelegate
/************************************************************/

@protocol NRChatViewDelegate <NSObject>
- (void)onReady;
- (void)addText:(NSString *)text isClient:(BOOL)isClient;
- (void)channel:(NSDictionary *)params;
- (void)readMore:(NSDictionary *)params;
- (void)linkedArticle:(NSString *)articleId title:(NSString *)title;
- (void)inlineChoice:(NSDictionary *)params;
- (void)location:(NSDictionary<NSString *, NSString *> *)params;
- (void)openInAppBrowser:(NSURLRequest *)request;
- (void)inAppNavigation:(NSString *)pageId;
- (void)share:(NSDictionary *)params;
- (void)customQuickOption:(NSDictionary *)params;
- (void)fetchPreviousHistory;
- (void)didFailWithError:(NSError *)error;
@end

/************************************************************/
// MARK: - NRChatView
/************************************************************/

@interface NRChatView : UIView
@property (nonatomic, weak) id<NRChatViewDelegate> chatViewDelegate;
@property (nonatomic, strong) id<ChatEventHandler> chatEventHandler;
@property (nonatomic, readonly) BOOL isLoaded;
@property (nonatomic) BOOL isRTL;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) ChatConfiguration *config;
@property (nonatomic) BOOL typing;

- (void)loadRequest:(NSURLRequest *)request;
- (void)reload;
- (void)removeMessages;
- (void)injectMessage:(NSString *)jsString isClient:(BOOL)isClient;
- (void)injectElement:(id<StorableChatElement>)element;
- (void)updateStatus:(NSString *)key;
@end
