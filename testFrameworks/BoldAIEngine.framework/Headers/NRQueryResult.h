
// NanorepUI version number: v1.8.2 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "NRChanneling.h"
#import "NRBaseResponse.h"

typedef NS_ENUM(NSInteger, LikeState) {
    LikeStatePositive,
    LikeStateNegative,
    LikeStateNotSelected
};

@interface NRQueryResultBody: NSObject
@property (nonatomic, copy) NSString *articleBody;
@property (nonatomic, copy) NSDictionary *extraData;
@end

@interface NRQueryResult : NRBaseResponse

@property (nonatomic, copy) NSString *resultId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NRQueryResultBody *body;
@property (nonatomic, readonly, copy) NSString *likes;
@property (nonatomic, readonly, copy) NSString *keywordsetId;
@property (nonatomic, copy) NSArray<NRChanneling *> *channeling;
@property (nonatomic) LikeState likeState;
@property (nonatomic, readonly, copy) NSString *hash;
@property (nonatomic, readonly) BOOL isContextSelectionOnly;
@property (nonatomic) NSString *dislikeText;

@property (nonatomic) BOOL isSupportCenterOrigin;

- (void)updteBody:(NSString *)body;
@end
