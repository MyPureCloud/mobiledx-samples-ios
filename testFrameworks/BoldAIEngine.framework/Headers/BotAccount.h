
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <BoldCore/Account.h>

/// use in case welcome message shoulb be disabled.
FOUNDATION_EXPORT NSString *const WelcomeMsgIdNone;

@interface DynamicContext: NSObject
- (instancetype)initWithContext:(NSString *)context;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *context;
@end

@interface BotAccount : Account
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *knowledgeBase;
@property (nonatomic, copy) NSString *kbID;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *nanorepContext;
@property (nonatomic, copy) NSString *referrer;
@property (nonatomic, readonly, copy) NSString *accountId;
@property (nonatomic, copy) NSString *labelId;
@property (nonatomic, copy, readonly) NSString *dynamicContextDescription;
@property (nonatomic) BOOL allContextsMandatory;
@property (nonatomic, copy) NSArray<NSString *> *entities;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *initializationEntities;
@property (nonatomic, copy) NSString *welcomeMessageId;
@property (nonatomic, copy) NSString *domain;

- (void)appendDynamicContext:(DynamicContext *)context;

- (NSDictionary<NSString *,NSString *> *)resetDynamicContext;
@end
