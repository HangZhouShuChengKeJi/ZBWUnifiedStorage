//
//  ZBWKeyChainStorage.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWKeyChainStorage.h"
#import <SAMKeychain/SAMKeychain.h>
#import "ZBWStorageObject.h"

@implementation ZBWKeyChainStorage


#pragma mark ZBWStorageInterface

- (ZBWStorageObject *)storageObjectForKey:(NSString *)key
{
    NSData *data = [SAMKeychain passwordDataForService:self.domain.domain account:key];
    return [ZBWStorageObject storageObjectWithData:data];
}

- (void)saveStorageObject:(ZBWStorageObject *)object
{
    NSData *data = [ZBWStorageObject data:object];
    [SAMKeychain setPasswordData:data forService:self.domain.domain account:object.key];
}

- (void)removeStorageObjectForKey:(NSString *)key
{
    [SAMKeychain deletePasswordForService:self.domain.domain account:key];
}

@end
