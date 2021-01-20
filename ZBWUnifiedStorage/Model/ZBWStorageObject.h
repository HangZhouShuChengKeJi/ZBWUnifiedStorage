//
//  ZBWStorageObject.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZBWStorageObjectInterface <NSObject>

@property (nonatomic) id value;
@property (nonatomic) NSString *key;
@property (nonatomic) NSDate *expirationDate;

@end

@interface ZBWStorageObject : NSObject<NSCoding>

@property (nonatomic) id value;
@property (nonatomic) NSString *key;
@property (nonatomic) NSDate *expirationDate;

@property (nonatomic) BOOL  removed;

#pragma mark- dictionary
+ (NSDictionary *)dictionary:(ZBWStorageObject *)object;
+ (ZBWStorageObject *)storageObjectWithDictionary:(NSDictionary *)dictionary;

#pragma mark- 归档
+ (NSData *)data:(ZBWStorageObject *)object;
+ (ZBWStorageObject *)storageObjectWithData:(NSData *)data;

- (BOOL)hasExpired;

@end
