
// NanorepUI version number: v2.4.8 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BCAccountConstants : NSObject

/** Language of the visitor (e.g., en-US). If the window does not support the language, it will fallback to the default language of the window. String value required. @since Version 1.0 */
extern NSString *const BCFormFieldLanguage;

/** The id of the department of the chat.  String value required. @since Version 1.0 */
extern NSString *const BCFormFieldDepartment;

/** The name of the visitor. String value required. @since Version 1.0 */
extern NSString *const BCFormFieldFirstName;

/** The name of the visitor (synonymous with first_name). String value required. @since Version 1.0 */
extern NSString *const BCFormFieldName;

/** The last name of the visitor. String value required. @since Version 1.0 */
extern NSString *const BCFormFieldLastName;

/** The phone number of the visitor. String value required. @since Version 1.0 */
extern NSString *const BCFormFieldPhone;

/** The email of the visitor. String value required. @since Version 1.0 */
extern NSString *const BCFormFieldEmail;

/** The initial question for the chat (which will show as the first chat message in the chat from the visitor). String value required. @since Version 1.0 */
extern NSString *const BCFormFieldInitialQuestion;

/** The visitor reference value that appears in the client. String value required. @since Version 1.0 */
extern NSString *const BCFormFieldReference;

/** The visitor info value that appears in the client. String value required. @since Version 1.0 */
extern NSString *const BCFormFieldInformation;

/** Survey overall response value. String with integer value required. @since Version 1.0 */
extern NSString *const BCFormFieldOverall;

/** Survey knowledge response value. String with integer value required. @since Version 1.0 */
extern NSString *const BCFormFieldKnowledge;

/** Survey responsiveness response value. String with integer value required. @since Version 1.0 */
extern NSString *const BCFormFieldResponsiveness;

/** Survey professionalism response value. String with integer value required. @since Version 1.0 */
extern NSString *const BCFormFieldProfessionalism;

/** Survey comments response value. String value required. @since Version 1.0 */
extern NSString *const BCFormFieldComments;

/** Custom url parameter @since Version 1.1 */
extern NSString *const BCFormFieldCustomUrl;

/** custom_[name] Sets the custom field (either pre or post chat) with the given name to the given value. String value required. @since Version 1.0 */
#define BCFormFieldComments(name) ([NSString stringWithFormat:@"custom_%@",name])
@end

NS_ASSUME_NONNULL_END
