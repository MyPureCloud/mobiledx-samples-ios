
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

/************************************************************/
// MARK: - BLDErrorType
/************************************************************/

typedef enum {
    /// Initial type.
    GeneralErrorType,
    /// Starting chat failed.
    BLDChatErrorTypeFailedToStart,
    /// Finishing chat failed.
    BLDChatErrorTypeFailedToFinish,
    /// Submitting chat form failed.
    BLDChatErrorTypeFailedToSubmitForm,
    /// Tried to escalate to live agent without passing access key
    BLDChatErrorTypeNoAccesseKeyForLiveChat,
    /// The app didn't implement handover
    BLDChatErrorTypeNoImplementationForHandOver
} BLDChatErrorType;

/************************************************************/
// MARK: - BLDError
/************************************************************/

@interface BLDError : NSError

/**
The error
 */
@property (nonatomic, strong, readonly, nullable) NSError *error;

/**
 Error Type
 */
@property (nonatomic) BLDChatErrorType type;

- (instancetype _Nonnull)initWithError:(NSError *_Nullable)error
                    errorType:(BLDChatErrorType)type;
@end
