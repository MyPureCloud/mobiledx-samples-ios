
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "FileUploadInfo.h"

NS_ASSUME_NONNULL_BEGIN


@interface BoldEvent: NSObject

+ (BoldEvent *)fileUploaded:(FileUploadInfo *)data;
@end



NS_ASSUME_NONNULL_END
