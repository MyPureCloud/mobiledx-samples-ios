
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

/************************************************************/
// MARK: - StatementStatus
/************************************************************/

/// An StatementStatus is an enum of different statemen states
typedef NS_ENUM(NSInteger, StatementStatus) {
    /// Sent when statement response status is ok
    OK = 0,
    /// Sent when statement response status is pending
    Pending = 1,
    /// Sent when statement response status is error
    Error = 2,
    /// Shouldn't be presented
    Repost = 3
};

