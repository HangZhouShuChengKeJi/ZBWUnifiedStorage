//
//  ZBWUSDefine.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern BOOL aZBWUS_LogSwitch;

#ifdef DEBUG

#define ZBWUS_Log(format,...)     \
do{\
    if(aZBWUS_LogSwitch){\
        NSLog([NSString stringWithFormat:@"\n【统一存储日志】\nstart>>> \n%@\n<<<end\n\n",format], ##__VA_ARGS__);\
        printf(\
        "\n【统一存储日志】\n \n<%s : %d> %s\n%s\n \n\n",\
        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
        __LINE__,\
        __func__,\
        [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]\
        );\
    }\
}while(0)

#else

#define ZBWUS_Log(fromat,...)

#endif



/**
 *  时间单位，也是时间精度
 */
typedef NS_ENUM(unsigned long, ZBWTimeUnit) {
    /**
     *  秒
     */
    ZBWTimeUnitSecond = 1,
    /**
     *  分钟
     */
    ZBWTimeUnitMinute = 60,
    /**
     *  小时
     */
    ZBWTimeUnitHour = 60*60,
    /**
     *  天
     */
    ZBWTimeUnitDay = 24*60*60,
    /**
     *  月
     */
    ZBWTimeUnitMonth,
    /**
     *  年
     */
    ZBWTimeUnitYear
};

/**
 *  过期时间的精度
 */
typedef NS_ENUM(NSInteger, ZBWTimeAccuracy) {
    /**
     *  秒
     */
    ZBWTimeAccuracySecond = 0,
    /**
     *  天
     */
    ZBWTimeAccuracyDay,
    /**
     *  月
     */
    ZBWTimeAccuracyMonth
};


/*
 【 ZBWStorageTypeDefault 】
  1）默认类型，为 内存+持久化;
 
 【 ZBWStorageTypeMemory 】
  1）内存长期保存，退出程序后清空。
 
 【 ZBWStorageTypePersistence 】
  1）需要持久化到本地的数据；
 
 【 ZBWStorageTypeMemoryAndPersistence 】
  1）需要持久化到本地的数据，数据需要频繁访问、修改，可以选择此类型；
 
 【 ZBWStorageTypeSecurityPersistence 】
  1）需要加密保存的数据；
 */

typedef NS_ENUM(NSInteger, ZBWStorageType)
{
    ZBWStorageTypeDefault = 0,
    ZBWStorageTypeMemory = 1 ,                              // 内存
    ZBWStorageTypePersistence = 2,                         // 持久化
    ZBWStorageTypeMemoryAndPersistence = ZBWStorageTypeDefault,                // 内存 + 持久化
    ZBWStorageTypeSecurityPersistence  = 3                  // keychain
};

