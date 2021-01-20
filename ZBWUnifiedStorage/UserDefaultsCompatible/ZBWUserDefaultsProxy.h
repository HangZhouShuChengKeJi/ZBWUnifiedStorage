//
//  ZBWUserDefaultsProxy.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/7/6.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#if ZBW_US_Compatible_UserDefaults

#import <Foundation/Foundation.h>
#import "ZBWUserDefaultsInterface.h"
@class ZBWStorage;

/**
 *  UserDefaultsStorage 的代理类
 */
@interface ZBWUserDefaultsProxy : NSObject<ZBWUserDefaultsInterface>

- (instancetype)initWithStorage:(ZBWStorage *)storage;

@end


#endif
