
// NanorepUI version number: v3.8.0 

//
//  InfoViewConfiguration.h
//  Bold360AI
//
//  Created by Nissim Pardo on 11/06/2019.
//  Copyright © 2019 nanorep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoViewConfiguration.h"

typedef NS_ENUM(NSInteger, InfoViewType) {
    InfoViewTypeAgentQueue,
    InfoViewTypeAgentTyping,
    InfoViewTypeUploadQueue
};

NS_ASSUME_NONNULL_BEGIN

@protocol ViewConfiguration <NSObject>
- (InfoViewConfiguration *)configurationForInfoViewType:(InfoViewType)type;
@end

NS_ASSUME_NONNULL_END
