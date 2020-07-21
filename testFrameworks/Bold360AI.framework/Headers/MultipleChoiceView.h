
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>

@interface MultipleChoiceView : UIView
@property (nonatomic, copy) NSString *firstOptionText;
@property (nonatomic, copy) NSString *secondOptionText;
@property (nonatomic, copy, readonly) NSString *pickedAnswer;
@property (nonatomic, readonly) int action;
@end
