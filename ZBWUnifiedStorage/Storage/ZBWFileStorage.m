//
//  ZBWFileStorage.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/23.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWFileStorage.h"

@implementation ZBWFileStorage

#pragma mark- ZBWStorageInterface

- (ZBWStorageObject *)storageObjectForKey:(NSString *)key
{
//    [self.domain dataInCacheFilePath:key];
    return nil;
}

- (void)saveStorageObject:(ZBWStorageObject *)object
{
    
}

- (void)removeStorageObjectForKey:(NSString *)key
{
    
}

@end
