
// NanorepUI version number: v3.8.7. 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <BoldCore/Account.h>
#import <BoldEngine/BCUnavailableReason.h>
#import "AvailabilityResult.h"

/************************************************************/
// MARK: - ChatAvailabilityChecker
/************************************************************/

@interface ChatAvailabilityChecker : NSObject

+ (void)checkAvailability:(Account *)account
               completion:(void(^)(AvailabilityResult *result))completion;
+ (void)fetchDepartments:(Account *)account
              completion:(void(^)(DepartmentResult *result))completion;
@end

