
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "NREntity.h"
#import "NROptionKind.h"
#import "NROptionType.h"
#import "ReadoutOption.h"

@interface NRConversationQuickOption : NSObject <ReadoutOption>
- (instancetype _Nullable)initWithParams:(NSDictionary *_Nullable)params;
@property(nonatomic, copy) NSString *_Nullable text;
@property(nonatomic, copy, readonly) NSString *_Nullable postback;
@property(nonatomic) NROptionType type;
@end

@interface NRConversationPersistentOption : NRConversationQuickOption
@property(nonatomic, copy, readonly) NSURL *_Nullable url;
@end

@interface NRConversationMissingEntity : NSObject
- (instancetype _Nullable)initWithStatement:(NSString *_Nullable)statement;

- (void)addEntity:(NREntity *_Nullable)entity;

@property(nonatomic, copy, readonly) NSString *_Nullable inJSON;
@end
