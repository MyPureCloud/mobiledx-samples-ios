
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2016 bold360ai(LogMeIn).
// BoldAIEngine SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const NRScriptsPath;
extern NSString *const NRFaqPath;
extern NSString *const NRWidgetPath;
extern NSString *const NRGifPath;

typedef NS_ENUM(NSInteger, NRPathType) {
    NRPathTypeScripts,
    NRPathTypeFaq,
    NRPathTypeWidget,
    NRPathTypeGIF
};

@interface NSString (BLDUtilities)
@property (nonatomic, readonly) NSString *bld_AppParams;
@property (nonatomic, readonly) NSMutableURLRequest *bld_RefererRequest;
@property (nonatomic, readonly) NSString *bld_Md5;
@property (nonatomic, readonly, copy) NSString *bld_WrappedBase64;
@property (nonatomic, readonly) NRPathType bld_PathType;
@property (nonatomic, readonly) UIColor *bld_Hex;
@property (nonatomic, readonly) NSDictionary *bld_ParseJSON;
@property (nonatomic, readonly) NSString *bld_MethodName;
@property (nonatomic, readonly) NSString *bld_Decode;
@property (nonatomic, readonly) NSString *bld_ResultId;
@property (nonatomic, readonly) NSString *bld_InHex;
@property (nonatomic, readonly, copy) NSArray *bld_ExtractExtraData;
@property (nonatomic, readonly) NSString *bld_ExtractSelector;
@property (nonatomic, readonly) NSString *bld_ExtractSignature;
@property (nonatomic, readonly) NSArray *bld_ExtractArguments;
@property (nonatomic, readonly) NSString *bld_InJsonText;
@property (nonatomic, readonly) NSString *bld_StringByStrippingHTML;
@property (nonatomic, readonly) NSString *bld_StringByStrippingHTMLTagsAndValues;
@property (nonatomic, readonly) NSAttributedString *bld_InHTMLText;
@property (nonatomic, readonly) BOOL bld_HasSpacePrefix;
@property (nonatomic, readonly) BOOL bld_IsValidInput;
@property (nonatomic, readonly) NSLocale *bld_InLocale;
@property (nonatomic, readonly) NSString *bld_InPlainText;
@property (nonatomic, copy, readonly) NSArray *bld_AccessComponents;
@end
