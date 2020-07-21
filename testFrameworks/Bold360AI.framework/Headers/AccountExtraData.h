
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/************************************************************/
// MARK: - AccountExtraData
/************************************************************/

@interface AccountExtraData : NSObject

/************************************************************/
// MARK: - Properties
/************************************************************/

/**
 The language code, for example "en-US".
 */
@property (nonatomic, copy) NSString *languageCode;

/**
 The name of the customer
 */
@property (nonatomic, copy) NSString *firstName;

/**
 The last name of the customer
 */
@property (nonatomic, copy) NSString *lastName;

/**
 The phone number of the customer
 */
@property (nonatomic, copy) NSString *phone;

/**
 The email of the customer
 */
@property (nonatomic, copy) NSString *email;

/************************************************************/
// MARK: - Functions
/************************************************************/
/**
 Existing keys values are being overided and new key are created with the custom_ prefix
 The default keys are listed in https://developer.bold360.com/help/EN/Bold360API/Bold360API/c_bc_sdk_ios_core_integration_chat_session.html
 And are fields in the AccountExtraData interface
*/
-(void)setExtraParams:(NSDictionary *)extraParams;
@end

/************************************************************/
// MARK: - LiveAccountExtraData
/************************************************************/

@interface LiveAccountExtraData : AccountExtraData
/**
 The indicator for disabaling pre chat.
 */
@property (nonatomic) BOOL shouldDisablePreChat;

/**
 The departmant id, used for check availability.
 */
@property (nonatomic, copy) NSString *departmentId;

/**
 The name of the customer (synonymous with firstName)
 */
@property (nonatomic, copy) NSString *name;

/**
 The initial question for the chat (which will show as
 the first chat message in the chat from the customer)
 */
@property (nonatomic, copy) NSString *initialQuestion;

/**
 The customer reference value that appears in the client
 */
@property (nonatomic, copy) NSString *reference;

/**
 The customer info value that appears in the client
 */
@property (nonatomic, copy) NSString *information;

/**
 Survey overall response value. The value needs to given in NSNumber
 */
@property (nonatomic, copy) NSString *overall;

/**
 Survey knowledge response value. The value needs to given in NSNumber
 */
@property (nonatomic, copy) NSString *knowledge;

/**
 Survey responsiveness response value. The value needs to given in NSNumber
 */
@property (nonatomic, copy) NSString *responsiveness;

/**
 Survey professionalism response value. The value needs to given in NSNumber
 */
@property (nonatomic, copy) NSString *professionalism;

/**
 Survey comments response value
 */
@property (nonatomic, copy) NSString *comments;

/**
 Custom redirect URL
 */
@property (nonatomic, copy) NSString *CustomUrl;
@end

/************************************************************/
// MARK: - AsyncAccountExtraData
/************************************************************/

@interface AsyncAccountExtraData : AccountExtraData

/**
Country Abbreviation.
*/
@property (nonatomic, copy) NSString *countryAbbrev;

/**
Profile Picture Link.
*/
@property (nonatomic, copy) NSString *profilePic;

@end

NS_ASSUME_NONNULL_END
