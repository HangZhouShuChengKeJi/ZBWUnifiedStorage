//
//  ZBWStorageFactory.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBWUSDefine.h"
#import "ZBWStorage.h"

typedef NS_ENUM(NSInteger, ZBWStoragePrivateType)
{
        ZBWStoragePrivateTypeUserDefaults = 9999,                                                     // NSUserDefaults
        ZBWStoragePrivateTypeKeyChain = ZBWStorageTypeSecurityPersistence,                         // KeyChain 钥匙串
        ZBWStoragePrivateTypeArchiver = ZBWStorageTypePersistence,                                 // 归档
        ZBWStoragePrivateTypeMemoryOnly = ZBWStorageTypeMemory,                                    // 内存 一直保存，退出后内存清空
        ZBWStoragePrivateTypeMemoryAndArchiver = ZBWStorageTypeMemoryAndPersistence                // 内存+归档， 内存紧张会归档，下次启动获取时，从归档中提取。
};

@interface ZBWStorageFactory : NSObject

+ (ZBWStorage *)createStorageByType:(ZBWStoragePrivateType)type;

@end
