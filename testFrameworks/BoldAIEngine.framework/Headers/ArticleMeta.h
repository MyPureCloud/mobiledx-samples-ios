
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - ArticleVisibility
/************************************************************/

/**
 Article visibility enum
 (it should be synchronized with console/backend
 when new visibility options are added)
 */
typedef NS_ENUM(NSInteger, ArticleVisibility) {
    Online = 1,
    // Use search to define visibility
    Search = 2,
    SupportCenter = 4,
    Faq = 8,
    DirectLink = 16,
    LinkToArticle = 32,
    AgentInterfaces = 64,
    Conversational = 128,
    SupportCenterRobotsTxt = 256,
    SupportCenterSitemapXml = 512,
    All = 255,
    DefaultValue = 255
};

/************************************************************/
// MARK: - ArticleMeta
/************************************************************/

@interface ArticleMeta : NSObject
- (instancetype _Nullable)initWithParams:(NSMutableDictionary *_Nullable)params;
@property (nonatomic, copy, readonly) NSArray *attachmentUrls;
@property (nonatomic, readonly) NSInteger visibility;
@property (nonatomic, readonly) NSInteger chatEscalationAction;
@end

NS_ASSUME_NONNULL_END
