
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

/************************************************************/
// MARK: - StatementScope
/************************************************************/

/// An StatementScope is an enum of different agent states
typedef enum {
/// Sent when agent type is bot
    StatementScopeBot = 0,
/// Sent when agent type is live
    StatementScopeLive = 1,
/// Sent when agent type is none
    StatementScopeNone = -1
}StatementScope;
