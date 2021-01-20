//
//  ZBWUserDefaultsProxy.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/7/6.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#if ZBW_US_Compatible_UserDefaults

#import "ZBWUserDefaultsProxy.h"
#import "ZBWStorage.h"
#import "ZBWUSCommon.h"

@interface ZBWUserDefaultsProxy ()

@property (nonatomic) ZBWStorage    *userDefaultsStorage;

@end

@implementation ZBWUserDefaultsProxy

- (instancetype)initWithStorage:(ZBWStorage *)storage
{
    if (self = [super init]) {
        self.userDefaultsStorage = storage;
    }
    return self;
}

- (void)setObject:(id)value forKey:(NSString *)key
{
    [self.userDefaultsStorage setObject:value forKey:key expirationDate:nil];
}

- (void)setObject:(id)value forKey:(NSString *)key expirationDate:(NSDate *)date
{
    [self.userDefaultsStorage setObject:value forKey:key expirationDate:date];
}

- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit
{
    [self setObject:value forKey:key expiration:expiration unit:unit accuracy:ZBWTimeAccuracySecond];
}
- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit accuracy:(ZBWTimeAccuracy)accuracy
{
    NSDate *expirationDate = zbw_US_expirationDate(expiration, unit, accuracy);
    [self.userDefaultsStorage setObject:value forKey:key expirationDate:expirationDate];
}
- (id)objectForKey:(NSString *)key
{
    return [self.userDefaultsStorage objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    [self.userDefaultsStorage removeObjectForKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [self setObject:@(value) forKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    [self setObject:@(value) forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString *)key
{
    [self setObject:@(value) forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
    [self setObject:@(value) forKey:key];
}

- (void)setString:(NSString *)value forKey:(NSString *)key
{
    [self setObject:value forKey:key];
}


- (BOOL)boolForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj boolValue];
    }
    return NO;
}

- (NSInteger)integerForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj integerValue];
    }
    return 0;
}

- (float)floatForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj floatValue];
    }
    return 0.0;
}

- (double)doubleForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj doubleValue];
    }
    return 0.0;
}

- (NSString *)stringForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return nil;
}

@end


#endif
