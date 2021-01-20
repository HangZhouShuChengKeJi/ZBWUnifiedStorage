//
//  ZBWUnifiedStorage.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/20.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWUnifiedStorage.h"
#import "ZBWStorage.h"
#import "ZBWStorageFactory.h"
#import "ZBWStorageDomain.h"
#import "ZBWUSCommon.h"

#if ZBW_US_Compatible_UserDefaults
#import "ZBWUserDefaultsProxy.h"
#endif

#define ZBWUnifiedStorageMainDomain @"default"

BOOL aZBWUS_LogSwitch = NO;

NSLock *globalUnifiedStorageLock()
{
    static dispatch_once_t onceToken;
    static NSLock *lock = nil;
    dispatch_once(&onceToken, ^{
        lock = [[NSLock alloc] init];
    });
    return lock;
}

NSMutableDictionary *globalUnifiedStorageMap()
{
    static dispatch_once_t onceToken;
    static NSMutableDictionary *globalUnifiedStorageMap = nil;
    dispatch_once(&onceToken, ^{
        globalUnifiedStorageMap = [NSMutableDictionary dictionaryWithCapacity:1];
    });
    return globalUnifiedStorageMap;
}


/**
 *  统一存储类
 */
@interface ZBWUnifiedStorage()

#if ZBW_US_Compatible_UserDefaults
@property (nonatomic) id<ZBWUserDefaultsInterface> userdefaultsProxy;      // userdefaults代理
#endif

@property (nonatomic) NSMutableDictionary *storageMap;
@property (nonatomic) ZBWStorageDomain    *domain;


@end


@implementation ZBWUnifiedStorage

#pragma mark- 静态方法
+ (instancetype)shareStorage
{
    static dispatch_once_t onceToken;
    static ZBWUnifiedStorage *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ZBWUnifiedStorage alloc] initWithDomain:ZBWUnifiedStorageMainDomain];
#if ZBW_US_Compatible_UserDefaults
        instance.userdefaultsProxy = [[ZBWUserDefaultsProxy alloc] initWithStorage:[instance storageOfType:ZBWStoragePrivateTypeUserDefaults]];
#endif
        // 添加到map中
        NSLock *lock = globalUnifiedStorageLock();
        [lock lock];
        
        NSMutableDictionary *unifiedStorageMap = globalUnifiedStorageMap();
        unifiedStorageMap[ZBWUnifiedStorageMainDomain] = instance;
        
        [lock unlock];
        
    });
    return instance;
}

#if ZBW_US_Compatible_UserDefaults
+ (id<ZBWUserDefaultsInterface>)shareUserDefaultsStorage
{
    ZBWUnifiedStorage *shareUS = [self shareStorage];
    id<ZBWUserDefaultsInterface> userdefaults = shareUS.userdefaultsProxy;
    return userdefaults;
}
#endif

+ (void)rigisterDomain:(NSString *)domain
{
    if (!domain) {
        return;
    }
    
    domain = [domain stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (domain.length == 0) {
        return;
    }
    
    domain = [domain lowercaseString];
    
    if ([domain isEqualToString:ZBWUnifiedStorageMainDomain]) {
        NSAssert(NO, ([NSString stringWithFormat:@">>>>>>>>>>>> %@域已经被注册过了", domain]));
    }
    
    // 检查是否已经注册，已注册，断言提示，未注册，创建US
    NSLock *lock = globalUnifiedStorageLock();
    [lock lock];
    NSMutableDictionary *unifiedStorageMap = globalUnifiedStorageMap();
    
    NSAssert(!unifiedStorageMap[domain], ([NSString stringWithFormat:@">>>>>>>>>>>> %@域已经被注册过了", domain]));
    
    ZBWUnifiedStorage *us = [[ZBWUnifiedStorage alloc] initWithDomain:domain];
    unifiedStorageMap[domain] = us;
    
    [lock unlock];
}

+ (instancetype)storageWithDomain:(NSString *)domain
{
    if (!domain) {
        return nil;
    }
    
    domain = [domain stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (domain.length == 0) {
        return nil;
    }
    
    domain = [domain lowercaseString];
    
    ZBWUnifiedStorage *us = nil;
    NSLock *lock = globalUnifiedStorageLock();
    [lock lock];
    
    NSMutableDictionary *unifiedStorageMap = globalUnifiedStorageMap();
    us = unifiedStorageMap[domain];
    
    [lock unlock];
    
    if (!us && [domain isEqualToString:ZBWUnifiedStorageMainDomain]) {
        us = [self shareStorage];
    }
    
    return us;
}


+ (void)openLog:(BOOL)isOpen
{
    aZBWUS_LogSwitch = isOpen;
}

#pragma mark- init
- (instancetype)initWithDomain:(NSString *)domain
{
    if (self = [self init]) {
        self.domain = [[ZBWStorageDomain alloc] initWithDomain:domain];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        _storageMap = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return self;
}


#pragma mark- public
#pragma mark- Set 设置保存

- (void)setObject:(id)value forKey:(NSString *)key
{
    ZBWStorageType type = [self defaultType];
    [self setObject:value forKey:key type:type];
}

- (void)setObject:(id)value forKey:(NSString *)key type:(ZBWStorageType)type
{
    [self setObject:value forKey:key expiration:0 unit:0 type:type];
}

- (void)setObject:(id)value forKey:(NSString *)key expirationDate:(NSDate *)date
{
    [self setObject:value forKey:key expirationDate:date type:[self defaultType]];
}

- (void)setObject:(id)value forKey:(NSString *)key expirationDate:(NSDate *)date type:(ZBWStorageType)type
{
    if (!key) {
        return;
    }
    
    ZBWStorage *storage = [self storageOfType:type];
    [storage setObject:value forKey:key expirationDate:date];
}

- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit
{
    [self setObject:value forKey:key expiration:expiration unit:unit type:[self defaultType]];
}

- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit type:(ZBWStorageType)type
{
    [self setObject:value forKey:key expiration:expiration unit:unit accuracy:ZBWTimeAccuracySecond type:type];
}

- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit accuracy:(ZBWTimeAccuracy)accuracy
{
    [self setObject:value forKey:key expiration:expiration unit:unit accuracy:accuracy type:[self defaultType]];
}

- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit accuracy:(ZBWTimeAccuracy)accuracy type:(ZBWStorageType)type
{
    if (!key) {
        return;
    }
    if (!value) {
        [self removeObjectForKey:key];
        return;
    }
    
    NSDate *expirationDate = zbw_US_expirationDate(expiration, unit, accuracy);
    
    [self setObject:value forKey:key expirationDate:expirationDate type:type];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [self setBool:value forKey:key type:[self defaultType]];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key type:(ZBWStorageType)type
{
    [self setObject:@(value) forKey:key type:type];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    [self setInteger:value forKey:key type:[self defaultType]];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key type:(ZBWStorageType)type
{
    [self setObject:@(value) forKey:key type:type];
}

- (void)setFloat:(float)value forKey:(NSString *)key
{
    [self setFloat:value forKey:key type:[self defaultType]];
}

- (void)setFloat:(float)value forKey:(NSString *)key type:(ZBWStorageType)type
{
    [self setObject:@(value) forKey:key type:type];
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
    [self setDouble:value forKey:key type:[self defaultType]];
}

- (void)setDouble:(double)value forKey:(NSString *)key type:(ZBWStorageType)type
{
    [self setObject:@(value) forKey:key type:type];
}

- (void)setString:(NSString *)value forKey:(NSString *)key
{
    [self setString:value forKey:key type:[self defaultType]];
}

- (void)setString:(NSString *)value forKey:(NSString *)key type:(ZBWStorageType)type
{
    [self setObject:value forKey:key type:type];
}

#pragma mark- Get 获取
- (id)objectForKey:(NSString *)key
{
    return [self objectForKey:key type:[self defaultType]];
}

- (id)objectForKey:(NSString *)key type:(ZBWStorageType)type
{
    ZBWStorage *storage = [self storageOfType:type];
    
    return [storage objectForKey:key];
}

- (BOOL)boolForKey:(NSString *)key
{
    return [self boolForKey:key type:[self defaultType]];
}

- (BOOL)boolForKey:(NSString *)key type:(ZBWStorageType)type
{
    id obj = [self objectForKey:key type:type];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj boolValue];
    }
    return NO;
}

- (NSInteger)integerForKey:(NSString *)key
{
    return [self integerForKey:key type:[self defaultType]];
}

- (NSInteger)integerForKey:(NSString *)key type:(ZBWStorageType)type
{
    id obj = [self objectForKey:key type:type];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj integerValue];
    }
    return 0;
}

- (float)floatForKey:(NSString *)key
{
    return [self floatForKey:key type:[self defaultType]];
}

- (float)floatForKey:(NSString *)key type:(ZBWStorageType)type
{
    id obj = [self objectForKey:key type:type];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj floatValue];
    }
    return 0.0;
}

- (double)doubleForKey:(NSString *)key
{
    return [self doubleForKey:key type:[self defaultType]];
}

- (double)doubleForKey:(NSString *)key type:(ZBWStorageType)type
{
    id obj = [self objectForKey:key type:type];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj doubleValue];
    }
    return 0.0;
}

- (NSString *)stringForKey:(NSString *)key
{
    return [self stringForKey:key type:[self defaultType]];
}

- (NSString *)stringForKey:(NSString *)key type:(ZBWStorageType)type
{
    id obj = [self objectForKey:key type:type];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return nil;
}

#pragma mark- 删除
- (void)removeObjectForKey:(NSString *)key
{
    [self removeObjectForKey:key type:[self defaultType]];
}

- (void)removeObjectForKey:(NSString *)key type:(ZBWStorageType)type
{
    ZBWStorage *storage = [self storageOfType:type];
    [storage removeObjectForKey:key];
}

/**
 *  获取指定类型的Storage
 *
 */
- (ZBWStorage *)storageOfType:(NSInteger)type
{
    ZBWStorage *storage = nil;
    @synchronized (self.storageMap) {
        storage = self.storageMap[@(type)];
        if (!storage) {
            storage = [ZBWStorageFactory createStorageByType:type];
            storage.domain = self.domain;
            if (type == ZBWStorageTypeMemoryAndPersistence) {
                storage.associatedStorage = [self storageOfType:ZBWStorageTypePersistence];
            }
            self.storageMap[@(type)] = storage;
        }
    }
    
    return storage;
}

#pragma mark- 工具方法
- (ZBWStorageType)defaultType
{
    return ZBWStorageTypeMemoryAndPersistence;
}

@end

