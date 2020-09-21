
// NanorepUI version number: v3.8.3 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <UIKit/UIKit.h>
#import "BoldForm.h"
#import "BoldFormConfiguration.h"

/************************************************************/
// MARK: - FormChatTableViewController
/************************************************************/

@interface FormChatTableViewController : UITableViewController <BoldForm>
@property (nonatomic, strong) BoldFormConfiguration *configuration;
@end
