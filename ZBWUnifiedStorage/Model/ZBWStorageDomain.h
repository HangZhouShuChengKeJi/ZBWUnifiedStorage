//
//  ZBWStorageDomain.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/22.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  统一存储的域，包括域名、文件路径等等
 */
@interface ZBWStorageDomain : NSObject

@property(nonatomic, readonly) NSString *domain;
@property (nonatomic, assign) BOOL          isDefaultDomain;

- (instancetype)initWithDomain:(NSString *)domain;

- (NSString *)archiverPathForKey:(NSString *)key;

- (NSString *)storageKeyForKey:(NSString *)key;



#pragma mark- 归档
/**
 *  保存指定key的数据到“归档”目录下
 *
 *  @param data 数据
 *  @param key  key
 */
- (void)storeDataInArchiverPath:(NSData *)data forKey:(NSString *)key;

/**
 *  在“归档”目录下，获取指定key的文件数据
 *
 *  @param key 指定的key
 *
 *  @return 文件数据
 */
- (NSData *)dataInArchiverPath:(NSString *)key;

/**
 *  删除对应key的文件
 *
 *  @param key 指定的key
 */
- (void)removeArchiverPathForKey:(NSString *)key;

#pragma mark- file

- (NSData *)dataInCacheFilePath:(NSString *)key;



@end
