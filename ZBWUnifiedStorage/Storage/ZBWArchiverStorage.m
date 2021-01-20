//
//  ZBWArchiverStorage.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWArchiverStorage.h"
#import "ZBWStorageObject.h"

@implementation ZBWArchiverStorage

#pragma mark ZBWStorageInterface

- (ZBWStorageObject *)storageObjectForKey:(NSString *)key
{
    NSData *data = [self.domain dataInArchiverPath:key];
    ZBWStorageObject *value = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return value;
}

- (void)saveStorageObject:(ZBWStorageObject *)object
{
    [self.domain storeDataInArchiverPath:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:object.key];
}

- (void)removeStorageObjectForKey:(NSString *)key
{
    [self.domain removeArchiverPathForKey:key];
}

@end
