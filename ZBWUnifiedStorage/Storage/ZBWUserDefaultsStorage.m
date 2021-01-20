//
//  ZBWUserDefaultsStorage.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWUserDefaultsStorage.h"
#import "ZBWStorageObject.h"

@implementation ZBWUserDefaultsStorage

#if ZBW_US_Compatible_UserDefaults

- (BOOL)needCompatible:(ZBWStorageObject *)object
{
    if (!self.domain.isDefaultDomain) {
        return NO;
    }
    
    if (object.expirationDate) {
        return NO;
    }
    
    if (!([object.value isKindOfClass:[NSString class]] ||
        [object.value isKindOfClass:[NSNumber class]] ||
        [object.value isKindOfClass:[NSData class]] ||
        [object.value isKindOfClass:[NSDictionary class]] ||
        [object.value isKindOfClass:[NSArray class]] ||
        [object.value isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    return YES;
}

#endif

#pragma mark- ZBWStorageInterface
- (void)saveStorageObject:(ZBWStorageObject *)object
{
#if ZBW_US_Compatible_UserDefaults
    if ([self needCompatible:object]) {
        [[NSUserDefaults standardUserDefaults] setObject:object.value forKey:object.key];
        return;
    }
#endif
    
    [[NSUserDefaults standardUserDefaults] setObject:[ZBWStorageObject data:object]
                                              forKey:object.key];
}

- (ZBWStorageObject *)storageObjectForKey:(NSString *)key
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (!value) {
        return nil;
    }
#if ZBW_US_Compatible_UserDefaults
    if (!self.domain.isDefaultDomain)
#endif
    {
        if (![value isKindOfClass:[NSData class]]) {
            return nil;
        }
        ZBWStorageObject *storageObject = [ZBWStorageObject storageObjectWithData:value];
        return storageObject;
    }
    
#if ZBW_US_Compatible_UserDefaults
    if ([value isKindOfClass:[NSData class]]) {
        ZBWStorageObject *storageObject = [ZBWStorageObject storageObjectWithData:value];
        if (storageObject) {
            return storageObject;
        }
    }
    ZBWStorageObject *storageObject = [[ZBWStorageObject alloc] init];
    storageObject.value = value;
    storageObject.key = key;
    return storageObject;
#endif
}


- (void)removeStorageObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
