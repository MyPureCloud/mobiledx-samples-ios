
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "PlaceholderConfiguration.h"
#import <BoldAIAccessibility/VoiceToVoiceConfiguration.h>

NS_ASSUME_NONNULL_BEGIN
@interface SearchViewConfiguration : PlaceholderConfiguration
@property (nonatomic, strong) AutoCompleteConfiguration * _Nullable autoCompleteConfiguration;
@property (nonatomic, strong) PlaceholderConfiguration * _Nullable placeholderConfiguration;
@property (nonatomic, strong) UIImage * _Nullable speechOnIcon;
@property (nonatomic, strong) UIImage * _Nullable speechOffIcon;
@property (nonatomic, strong) UIImage * _Nullable readoutIcon;
@property (nonatomic, strong) UIImage * _Nullable keyboardIcon;
@property (nonatomic, strong) UIImage * _Nullable sendIcon;
@property (nonatomic, strong) UIImage * _Nullable uploadIcon;
// whether or not to enable recording
@property (nonatomic, copy) NSNumber *voiceEnabled;
//  Specifies the BCP-47 language tag representing the language for voice recognition.
/// Examples: en-US (U.S. English), fr-CA (French Canadian)
@property (nonatomic, copy) NSString *languageCode;
@end

NS_ASSUME_NONNULL_END
