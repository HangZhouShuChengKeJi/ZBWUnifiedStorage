//
//  ZBWUserDefaultsInterface.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/7/6.
//  Copyright © 2016年 Bowen. All rights reserved.
//

//#if ZBW_US_Compatible_UserDefaults

#import <Foundation/Foundation.h>
#import "ZBWUSDefine.h"

/**
 *  NSUserDefaults的接口，用于兼容NSUserDefaults
 */
@protocol ZBWUserDefaultsInterface <NSObject>

#pragma mark- Set保存
- (void)setObject:(id)value forKey:(NSString *)key;
- (void)setObject:(id)value forKey:(NSString *)key expirationDate:(NSDate *)date;
- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit;
- (void)setObject:(id)value forKey:(NSString *)key expiration:(long)expiration unit:(ZBWTimeUnit)unit accuracy:(ZBWTimeAccuracy)accuracy;

- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setString:(NSString *)value forKey:(NSString *)key;

#pragma mark- Get 取值
- (id)objectForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;

#pragma mark- Remove 删除
- (void)removeObjectForKey:(NSString *)key;


@end

//#endif
