
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import <BoldAIEngine/SupportCenterItem.h>
#import "LabelDelegate.h"
#import <BoldAIEngine/BotAccount.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SupportCenterDataSource : NSObject

- (instancetype)initWithAccount:(BotAccount *)account;

@property (nonatomic, strong) id<SupportCenterItem> item;
@property (nonatomic, strong) id<LabelDelegate> delegate;
@property (nonatomic, readonly) NSInteger size;
- (id<SupportCenterItem>)itemAtIndex:(NSInteger)index;
- (UIImage *)fetchIconForIndex:(NSInteger)index;
- (void)updateCurrentSelection;
- (void)back;
@end

NS_ASSUME_NONNULL_END
