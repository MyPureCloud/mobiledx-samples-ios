
// NanorepUI version number: v2.4.8 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Department : NSObject
@property (nonatomic, copy) NSString* departmentId;
@property (nonatomic, copy) NSString* language;
@property (nonatomic, copy) NSString* name;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
