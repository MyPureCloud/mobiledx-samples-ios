
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <BoldCore/BoldCore.h>
#import "AccountExtraData.h"

/************************************************************/
// MARK: - LiveAccount
/************************************************************/

@interface LiveAccount : Account

/************************************************************/
// MARK: - Properties
/************************************************************/

/**
 The extra data of account.
 */
@property (nonatomic, strong) LiveAccountExtraData *extraData;

@end
