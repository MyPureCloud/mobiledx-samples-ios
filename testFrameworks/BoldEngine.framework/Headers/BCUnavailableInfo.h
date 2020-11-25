
// NanorepUI version number: v2.4.8 

//
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCUnavailableReason.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCUnavailableInfo : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic) BCUnavailableReason reason;

- (instancetype)initWithMessage:(NSString *)message
                         reason:(BCUnavailableReason)reason;
@end

NS_ASSUME_NONNULL_END
