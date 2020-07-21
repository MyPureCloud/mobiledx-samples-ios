
// NanorepUI version number: v3.8.0 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>
#import "BoldCellInjector.h"

/************************************************************/
// MARK: - CellInjectorFactory
/************************************************************/

@interface CellInjectorFactory : NSObject
+ (id<BoldCellInjector>)createInjector:(BCFormField *)cellData;
@end
