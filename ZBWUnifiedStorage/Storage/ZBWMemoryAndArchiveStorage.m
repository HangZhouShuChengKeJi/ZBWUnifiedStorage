//
//  ZBWMemoryAndArchiveStorage.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/23.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWMemoryAndArchiveStorage.h"
#import "ZBWMemoryStorage.h"
#import "ZBWArchiverStorage.h"
#import "ZBWStorageObject.h"
#import <UIKit/UIKit.h>
#import "ZBWArchiverStorage.h"

#define ZBW_MemoryAndArchive_Prefix     @"_MemoryAndArchive_"

@interface ZBWMemoryAndArchiveStorage ()<NSCacheDelegate>

@property (nonatomic) NSCache *cache;

@end

@implementation ZBWMemoryAndArchiveStorage


- (instancetype)init
{
    if (self = [super init]) {
        self.cache = [[NSCache alloc] init];
        self.cache.delegate = self;
//        self.cache.countLimit = 20;
//        self.cache.totalCostLimit = 1024 * 1024 * 2; // 2M
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)prefixedKey:(NSString *)key
{
    if ([key hasPrefix:ZBW_MemoryAndArchive_Prefix]) {
        return key;
    }
    return [NSString stringWithFormat:@"%@",key];
}

- (NSString *)originalKey:(NSString *)prefixedKey
{
    if ([prefixedKey hasPrefix:ZBW_MemoryAndArchive_Prefix]) {
        return [prefixedKey substringFromIndex:ZBW_MemoryAndArchive_Prefix.length];
    }
    return prefixedKey;
}

#pragma mark- Event

- (void)onMemoryWarning
{
    [self.cache removeAllObjects];
}

#pragma mark- ZBWStorageInterface

- (ZBWStorageObject *)storageObjectForKey:(NSString *)key
{
    // 从内存缓存中获取
    ZBWStorageObject *obj = [self.cache objectForKey:key];
    if (obj) {
        return obj;
    }
    
    // 从归档文件中获取
    obj = [(id<ZBWStorageInterface>)self.associatedStorage storageObjectForKey:[self prefixedKey:key]];
    
    // 保存到内存缓存中
    if (obj) {
        obj.key = key;
        ZBWUS_Log(@"class【%@】domain【%@】\n从归档文件中获取！\nkey=%@\nvalue=%@\nstorageObj=%@",
                  NSStringFromClass(self.class),
                  self.domain.domain,
                  obj.key,
                  obj.value,
                  obj);
        [self.cache setObject:obj forKey:key];
    }
    
    return obj;
}

- (void)saveStorageObject:(ZBWStorageObject *)object
{
    NSString *key = object.key;
    
    ZBWStorageObject *oldObj = [self.cache objectForKey:key];
    if (oldObj) {
        oldObj.removed = YES;
    }
    
    // 加入到内存缓存
    [self.cache setObject:object forKey:key];
    
    ZBWUS_Log(@"class【%@】domain【%@】\nsave到归档文件中！\nkey=%@\nvalue=%@\nstorageObj=%@",
              NSStringFromClass(self.class),
              self.domain.domain,
              object.key,
              object.value,
              object);
    // 加入到归档中
    object.key = [self prefixedKey:key];
    [(id<ZBWStorageInterface>)self.associatedStorage saveStorageObject:object];
    object.key = key;
}

- (void)removeStorageObjectForKey:(NSString *)key
{
    ZBWStorageObject *oldObj = [self.cache objectForKey:key];
    if (oldObj) {
        oldObj.removed = YES;
    }
    
    [self.cache removeObjectForKey:key];
    [(id<ZBWStorageInterface>)self.associatedStorage removeStorageObjectForKey:[self prefixedKey:key]];
}


#pragma mark- NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    if (![obj isKindOfClass:[ZBWStorageObject class]]) {
        ZBWUS_Log(@"class【%@】domain【%@】\n【error】对象从内存中移除，进行归档保存！但是obj不是ZBWStorageObject对象, obj=%@",
                  NSStringFromClass(self.class),
                  self.domain.domain,
                  obj);
        return;
    }
    ZBWStorageObject *storageObj = (ZBWStorageObject *)obj;
    NSString *key = storageObj.key;
    
    // 已过期，清理数据
    if (storageObj.removed || [storageObj hasExpired]) {
        ZBWUS_Log(@"class【%@】domain【%@】\n对象从内存中移除，(过期或被删除)并且删除本地归档！\nkey=%@\nvalue=%@\nstorageObj=%@",
                  NSStringFromClass(self.class),
                  self.domain.domain,
                  key,
                  storageObj.value,
                  storageObj);
        [(id<ZBWStorageInterface>)self.associatedStorage removeStorageObjectForKey:[self prefixedKey:storageObj.key]];
        return;
    }
    
    ZBWUS_Log(@"class【%@】domain【%@】\n对象从内存中移除，进行归档保存！\nkey=%@\nvalue=%@\nstorageObj=%@",
              NSStringFromClass(self.class),
              self.domain.domain,
              key,
              storageObj.value,
              storageObj);
    // 加入到归档中
    storageObj.key = [self prefixedKey:key];
    [(id<ZBWStorageInterface>)self.associatedStorage saveStorageObject:storageObj];
    storageObj.key = key;
}

@end
