
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "AsyncMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface AsyncChatConfig : JSONObject
@property (nonatomic, copy) NSString *Language;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *Brandings;
@property (nonatomic, copy) NSString *StompUrl;
@property (nonatomic, copy) NSString *OutgoingTopicId;
@property (nonatomic, copy) NSString *Status;
@end

NS_ASSUME_NONNULL_END
