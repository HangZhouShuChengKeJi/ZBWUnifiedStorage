//
//  ZBWStorage.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWStorage.h"
#import "ZBWStorageObject.h"

@interface ZBWStorage ()

@end

@implementation ZBWStorage

- (void)setObject:(id)value forKey:(NSString *)key expirationDate:(NSDate *)expirationDate
{
    ZBWStorageObject *storageObject = [[ZBWStorageObject alloc] init];
    storageObject.expirationDate = expirationDate;
    storageObject.value = value;
    
#if ZBW_US_Compatible_UserDefaults
    if (self.domain.isDefaultDomain && [self isKindOfClass:NSClassFromString(@"ZBWUserDefaultsStorage")]) {
        storageObject.key = key;
    } else
#endif
    {
        storageObject.key = [self.domain storageKeyForKey:key];
    }
    
    [(id<ZBWStorageInterface>)self saveStorageObject:storageObject];
}

- (id)objectForKey:(NSString *)key
{
    NSString *storageKey = key;
#if ZBW_US_Compatible_UserDefaults
    if (self.domain.isDefaultDomain && [self isKindOfClass:NSClassFromString(@"ZBWUserDefaultsStorage")]) {
        storageKey = key;
    } else
#endif
    {
        storageKey = [self.domain storageKeyForKey:key];
    }
    ZBWStorageObject *storageObj = nil;
    
    // 如果数据反序列化失败，可能是由于类名修改了。 删除数据。
    @try {
        storageObj = [(id<ZBWStorageInterface>)self storageObjectForKey:storageKey];
    } @catch (NSException *exception) {
        [self removeObjectForKey:storageKey];
    } @finally {
        
    }
    if (!storageObj) {
        return nil;
    }
    
#if DEBUG
    // key 校验
    if (![storageKey isEqualToString:storageObj.key]) {
        ZBWUS_Log(@"key不匹配！\n【%@】【%@】\n [%@] != [%@]",
                  NSStringFromClass(self.class),
                  self.domain.domain,
                  storageKey,
                  storageObj.key);
        return nil;
    }
#endif
    // 有效期 校验
    if ([storageObj hasExpired]) {
        ZBWUS_Log(@"数据过期了！\n【%@】【%@】\nkey=%@\n%@",
                  NSStringFromClass(self.class),
                  self.domain.domain,
                  key,
                  storageObj.value);
        [(id<ZBWStorageInterface>)self removeStorageObjectForKey:storageKey];
        
        return nil;
    }
    
    return storageObj.value;
}

- (void)removeObjectForKey:(NSString *)key
{
    NSString *storageKey = key;
#if ZBW_US_Compatible_UserDefaults
    if (self.domain.isDefaultDomain && [self isKindOfClass:NSClassFromString(@"ZBWUserDefaultsStorage")]) {
        storageKey = key;
    } else
#endif
    {
        storageKey = [self.domain storageKeyForKey:key];
    }
    [(id<ZBWStorageInterface>)self removeStorageObjectForKey:storageKey];
}

@end
