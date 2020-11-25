
// NanorepUI version number: v3.4.7 

// ===================================================================================================
// Copyright © 2018 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface Resource<ObjectType> : NSObject

typedef ObjectType _Nullable(^ParserBlock)(NSData *data);

@property (nonatomic, readonly, copy) NSMutableURLRequest *request;
@property (nonatomic, readonly, copy) ParserBlock parser;

- (instancetype)initWithRequest:(NSMutableURLRequest *)request parser:(ParserBlock)parser;
@end

@interface Result<ObjectType> : NSObject
+ (Result *)errorResult:(NSError *)error;
+ (Result *)successResult:(ObjectType)success;
@property (nonatomic) ObjectType success;
@property (nonatomic, copy) NSError *error;
@end

@interface Future<ObjectType> : NSObject

typedef void (^Callback)(Result<ObjectType> *result);

@property (nonatomic, strong) NSMutableArray *callbacks;
@property (nonatomic) Result<ObjectType> *cached;

- (instancetype)initWithCompute:(void (^)(Callback))compute;

@property (nonatomic, copy) void (^compute)(Callback);

- (void)onResult:(Callback)callback;

@end

@interface Future<ObjectType> (Map)
- (Future<ObjectType> *)map:(ObjectType (^)(id value))f;
@end


NS_ASSUME_NONNULL_END
