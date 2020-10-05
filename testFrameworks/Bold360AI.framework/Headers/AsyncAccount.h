
// NanorepUI version number: v3.8.6 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import "AccountExtraData.h"
#import <BoldCore/Account.h>

NS_ASSUME_NONNULL_BEGIN

@interface AsyncAccount : Account

/************************************************************/
// MARK: - Properties
/************************************************************/

/**
 The extra data of account.
 */
@property (nonatomic, strong) AsyncAccountExtraData *extraData;

/**
The user id of account.
*/
@property (nonatomic, copy) NSString *userId;

/**
The application id of account.
*/
@property (nonatomic, copy) NSString *applicationId;

/**
The socket request of account.
*/
@property (nonatomic, copy, readonly) NSURLRequest *socketRequest;
@end

NS_ASSUME_NONNULL_END
