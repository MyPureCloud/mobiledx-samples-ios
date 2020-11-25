
// NanorepUI version number: v3.8.10 

// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LabelDelegate <NSObject>
- (void)loadData;
- (void)reloadAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
