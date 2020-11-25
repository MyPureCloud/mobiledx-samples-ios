
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TrackKey) {
    FIRST_QUERY_BOLD  = 0,
    IN_QUEUE = 1,
    PRECHAT_PRESENTED = 2,
    PRECHAT_SUBMITTED = 3,
    POSTCHAT_PRESENTED = 4,
    POSTCHAT_SUBMITTED = 5,
    UNAVAILABLE = 6,
    AGENT_ACCEPTED = 7,
    FIRST_QUERY_BOT = 8,
    CHANNELED = 9,
    MESSAGE_BOT_QUERY = 10,
    TrackKeysCount // keep track of the enum size automatically
} ;

typedef NS_ENUM(NSInteger, TrackQueryParameter) {
    TRACK_TYPED_MESSAGE  = 0,
    TRACK_FAQ = 1,
    TRACK_QUICK_OPTION = 2,
    TRACK_AUTOCOMPLETE = 3,
    TRACK_PHONE_CHANNEL = 4,
    TRACK_TICKET_CHANNEL = 5,
    TRACK_LIVE_CHANNEL = 6,
    FORM_SUBMITTED_ACTION = 7,
    FORM_PRESENTED_ACTION = 8,

    TrackQuerysParametersCount // keep track of the enum size automatically
} ;

extern NSString * _Nonnull const TrackKeys[TrackKeysCount];
extern NSString * _Nonnull const TrackQueryParameters[TrackQuerysParametersCount];

@interface TrackParamsConstants : NSObject
@property (nonatomic, assign) TrackKey trackKey;
@property (nonatomic, assign) TrackQueryParameter trackQuery;
@end

NS_ASSUME_NONNULL_END
