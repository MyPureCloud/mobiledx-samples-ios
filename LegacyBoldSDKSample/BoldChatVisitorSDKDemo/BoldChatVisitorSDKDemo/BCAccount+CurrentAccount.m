//
//  BCAccount+CurrentAccount.m
//  Copyright (c) 2014 LogMeIn Inc. All rights reserved.
//

#import "BCAccount+CurrentAccount.h"
//#import "BCAccount+ServerSet.h"

#import <Security/Security.h>


NSString *KeyChainAccessKeyKey = @"KeyChainAccessKeyKey";
NSString *ServerSetKey = @"ServerSetKey";

@interface KeychainWrapper : NSObject {
    
}

+ (id)setValue:(NSString *)value forKey:(NSString *)key;
+ (NSString *)searchKeychainCopyMatching:(NSString *)identifier;
+ (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier;
+ (BOOL)updateKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier;
+ (void)deleteKeychainValue:(NSString *)identifier;
@end



@implementation BCAccount (CurrentAccount)

+ (BCAccount *)currentAccount {
//    TODO:: Add Your Access Key
    NSString *accessKey = Your_Access_Key;
//    NSString *accessKey = [KeychainWrapper searchKeychainCopyMatching:KeyChainAccessKeyKey];
    NSString *serverSet = [KeychainWrapper searchKeychainCopyMatching:ServerSetKey];
    BCAccount *account;
    
    if (accessKey) {
        account = [BCAccount accountWithAccessKey:accessKey];
    }
        
    //not to override if set to live
    if (serverSet.length) {
        [account performSelector:@selector(setServerSet:) withObject:serverSet];
    }
    
    return account;
    
    //return [BCAccount accountWithAccessKey:<place your access key here>];
}

+ (void)setUpAccount:(NSURL *)url {
    NSString *serverSet = [url host];
    NSString *accessKey = [url path];
    
    if ((!serverSet || serverSet.length == 0) && (!accessKey || accessKey.length == 0)) {
        //no serverset and access key given
        return;
    }
    
    if (!accessKey || accessKey.length<2) {
        accessKey = serverSet;
        serverSet = @"";
    } else if ([[serverSet lowercaseString] isEqualToString:@"gamma"] || [[serverSet lowercaseString] isEqualToString:@"prod"]) {
        serverSet = @"";
    }
    accessKey = [accessKey substringFromIndex:1];
    
    [KeychainWrapper setValue:accessKey forKey:KeyChainAccessKeyKey];
    [KeychainWrapper setValue:serverSet forKey:ServerSetKey];

    
}

@end

@implementation KeychainWrapper
static NSString *serviceName = @"com.boldchat";

+ (id)setValue:(NSString *)value forKey:(NSString *)key {
    if(value != nil) {
        NSString *oldValue = [KeychainWrapper searchKeychainCopyMatching:key];
        if(oldValue == nil) {
            [KeychainWrapper createKeychainValue:value forIdentifier:key];
        } else {
            [KeychainWrapper updateKeychainValue:value forIdentifier:key];
        }
        return value;
    } else {
        [KeychainWrapper deleteKeychainValue:key];
        return nil;
    }
}

+ (NSMutableDictionary *)searchDictionary:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(id)kSecAttrService];
    
    return searchDictionary;
}

+ (NSString *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [KeychainWrapper searchDictionary:identifier];
    
    // Add search attributes
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    CFDictionaryRef searchDictionaryRef = (__bridge_retained CFDictionaryRef)searchDictionary;
    CFDataRef cfresult = NULL;
    SecItemCopyMatching(searchDictionaryRef, (CFTypeRef *)&cfresult);
    CFRelease(searchDictionaryRef);
    NSData *result = (__bridge_transfer NSData *)cfresult;
    if(result) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+ (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [KeychainWrapper searchDictionary:identifier];
    
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:valueData forKey:(id)kSecValueData];
    
    OSStatus status = SecItemAdd((CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [KeychainWrapper searchDictionary:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:valueData forKey:(id)kSecValueData];
    
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    
    //[updateDictionary release];
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (void)deleteKeychainValue:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [KeychainWrapper searchDictionary:identifier];
    SecItemDelete((CFDictionaryRef)searchDictionary);
}

@end
