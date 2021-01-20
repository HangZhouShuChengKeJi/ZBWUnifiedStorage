//
//  ZBWStorage.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBWUSDefine.h"
#import "ZBWStorageDomain.h"

@class ZBWStorageObject;

/**
 *  存储器接口类
 *  所有的存储器实现类，必须实现此接口
 */
@protocol ZBWStorageInterface <NSObject>

@required
- (ZBWStorageObject *)storageObjectForKey:(NSString *)key;
- (void)saveStorageObject:(ZBWStorageObject *)object;
- (void)removeStorageObjectForKey:(NSString *)key;

@end


/**
 *  存储器基类。
 *  对“统一存储”提供存、取接口；包装存放的数据；
 */
@interface ZBWStorage : NSObject

@property (nonatomic) ZBWStorageDomain      *domain;
@property (nonatomic, weak) ZBWStorage      *associatedStorage;

- (id)objectForKey:(NSString *)key;

- (void)setObject:(id)value forKey:(NSString *)key expirationDate:(NSDate *)expirationDate;

- (void)removeObjectForKey:(NSString *)key;
@end
