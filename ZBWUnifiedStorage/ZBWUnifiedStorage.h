//
//  ZBWUnifiedStorage.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/20.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBWUSDefine.h"

#if ZBW_US_Compatible_UserDefaults
#import "ZBWUserDefaultsInterface.h"
#endif


#if ZBW_US_Compatible_UserDefaults

// 全局ShareUserDefaults, 完美兼容NSUserDefaults
#define ZBW_ShareUserDefaults       ((id<ZBWUserDefaultsInterface>)[ZBWUnifiedStorage shareUserDefaultsStorage])

#endif

// 全局“统一存储”
#define ZBW_ShareStorage            ([ZBWUnifiedStorage shareStorage])


@interface ZBWUnifiedStorage : NSObject

/**
 *  共享的“统一存储”，domain为“default”
 *
 */
+ (instancetype)shareStorage;

#if ZBW_US_Compatible_UserDefaults
+ (id<ZBWUserDefaultsInterface>)shareUserDefaultsStorage;
#endif

/**
 *  获取指定域的“统一存储”
 *
 *  @param domain 指定的域
 *
 */
+ (instancetype)storageWithDomain:(NSString *)domain;

+ (void)openLog:(BOOL)isOpen;

/**
 *  自己的“统一存储”沙盒，必须先rigister，避免与其他的“沙盒”冲突
 *
 *  @param domain 沙盒域
 */
+ (void)rigisterDomain:(NSString *)domain;

#pragma mark- 保存 object
- (void)setObject:(id)value forKey:(NSString *)key;
- (void)setObject:(id)value forKey:(NSString *)key type:(ZBWStorageType)type;
- (void)setObject:(id)value forKey:(NSString *)key expirationDate:(NSDate *)date;
- (void)setObject:(id)value forKey:(NSString *)key expirationDate:(NSDate *)date type:(ZBWStorageType)type;
- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit;
- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit type:(ZBWStorageType)type;
- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit accuracy:(ZBWTimeAccuracy)accuracy;
- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit accuracy:(ZBWTimeAccuracy)accuracy type:(ZBWStorageType)type;

#pragma mark- 保存 基本数据类型
- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key type:(ZBWStorageType)type;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key type:(ZBWStorageType)type;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key type:(ZBWStorageType)type;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key type:(ZBWStorageType)type;
- (void)setString:(NSString *)value forKey:(NSString *)key;
- (void)setString:(NSString *)value forKey:(NSString *)key type:(ZBWStorageType)type;

#pragma mark- 读取
- (id)objectForKey:(NSString *)key;
- (id)objectForKey:(NSString *)key type:(ZBWStorageType)type;

#pragma mark- 读取 基本数据类型
- (BOOL)boolForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key type:(ZBWStorageType)type;
- (NSInteger)integerForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key type:(ZBWStorageType)type;
- (float)floatForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key type:(ZBWStorageType)type;
- (double)doubleForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key type:(ZBWStorageType)type;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key type:(ZBWStorageType)type;

#pragma mark- 删除
- (void)removeObjectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key type:(ZBWStorageType)type;

@end

/**
 *  保存数据
 *
 *  @param value      数据对象
 *  @param key        关键字
 *  @param expiration 多长时间后过期，例如 10
 *  @param unit       时间单位，例如 (分钟 -> ZBWTimeUnitMinute)
 *  @param accuracy   时间精度，例如 (天 -> ZBWTimeAccuracyDay)
 *  @param type       存储类型。
 *
 * 【例如】
 *  [self setObject:@"zhubowen" forKey:@"usename" expiration:5 unit:ZBWTimeUnitDay accuracy:ZBWTimeAccuracyDay type:ZBWStorageTypeKeyChain];
 *  使用“钥匙串”存储数据， 5天后过期，精度为“天”，即“第五天的零点钟过期”。如果精度为“秒”，代表“第五天的当前时间点过期”
 */



