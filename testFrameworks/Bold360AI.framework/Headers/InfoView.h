
// NanorepUI version number: v3.8.6 

//
//  InfoView.h
//  Bold360AI
//
//  Created by Nissim Pardo on 11/06/2019.
//  Copyright © 2019 nanorep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface InfoView : UIView
@property (nonatomic) InfoViewConfiguration *config;
@property (nonatomic, copy) NSString *text;
@end

NS_ASSUME_NONNULL_END
