
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// NanorepUI SDK.
// All rights reserved.
// ===================================================================================================

#import <BoldEngine/BoldEngine.h>
#import "PreChatBrand.h"

/************************************************************/
// MARK: - BrandedForm
/************************************************************/

@interface BrandedForm : BCForm

/**
 The Form (PreChat, PostChat..).
 */
@property (nonatomic, strong, readonly) BCForm *form;

/**
 The PreChat Branded Object
 */
@property (nonatomic, strong, readonly) ChatBrand *chatBrand;

/**
 Whole Brandind Dictionary
 */
@property (nonatomic, copy, readonly) NSDictionary *globalBranding;

/**
 BrandedForm Initializer
 
 @param form The `BCForm` object, contains all needed for creating a form.
 @return returns `BrandedForm` with relevant brand.
 */
- (instancetype)initWithForm:(BCForm *)form branding:(NSDictionary *)branding;

@end
