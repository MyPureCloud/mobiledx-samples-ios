
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <BoldEngine/BCUnavailableReason.h>
#import <BoldEngine/Department.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvailabilityResult : NSObject
@property (nonatomic) BOOL isAvailable;
@property (nonatomic) BCUnavailableReason reason;
@property (nonatomic, copy, nullable) NSError *error;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *apiKey;
@end

@interface DepartmentResult : NSObject
@property (nonatomic, copy, nullable) NSArray<Department *> *departments;
@property (nonatomic, copy, nullable) NSError *error;
@property (nonatomic, copy) NSString *apiKey;
@end

NS_ASSUME_NONNULL_END
