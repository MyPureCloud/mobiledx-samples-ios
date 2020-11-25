
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UploadFileType) {
    UploadFileTypeExcel  = 0,
    UploadFileTypeArchive = 1,
    UploadFileTypePicture = 2,
    UploadFileTypeDefault = 3,

    UploadFileTypeCount // keep track of the enum size automatically
} ;

extern NSString * _Nonnull const UploadFileTypeName[UploadFileTypeCount];

@interface UploadRequest : NSMutableURLRequest
@property (nonatomic, copy) NSString *boundary;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) UploadFileType fileType;
@property (nonatomic, copy) NSData *fileData;
@end

NS_ASSUME_NONNULL_END
