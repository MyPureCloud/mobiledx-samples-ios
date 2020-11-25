
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TrackingDatasource <NSObject>
@optional
@property (nonatomic, copy) NSString *sessionID;
@property (nonatomic, copy, readonly) NSURLComponents *baseUrlComp;
@property (nonatomic, copy, readonly) NSString *accountName;
@property (nonatomic, copy, readonly) NSString *knowledgeBase;
@property (nonatomic, readonly) NSInteger contextsNumber;
@property (nonatomic, copy, readonly) NSString *kbLanguage;
@property (nonatomic, copy) NSString *from;;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *chatProvider;
@property (nonatomic) BOOL answerReadup;
@property (nonatomic) NSUInteger answerCount;
@property (nonatomic) NSUInteger answerLength;
@property (nonatomic, copy) NSString *answerType;

@end

NS_ASSUME_NONNULL_END
