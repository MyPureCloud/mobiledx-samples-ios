//
//  BCAccount+CurrentAccount.h
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import <BoldEngineUI/BoldEngineUI.h>

@interface BCAccount (CurrentAccount)

+ (BCAccount *)currentAccount;

+ (void)setUpAccount:(NSURL *)url;

@end
