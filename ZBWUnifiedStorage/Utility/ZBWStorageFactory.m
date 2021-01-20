//
//  ZBWStorageFactory.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWStorageFactory.h"
#import <objc/runtime.h>

@implementation ZBWStorageFactory

+ (ZBWStorage *)createStorageByType:(ZBWStoragePrivateType)type
{
    NSString *string = nil;
    switch (type) {
        case ZBWStoragePrivateTypeUserDefaults:
            string = @"ZBWUserDefaultsStorage";
            break;
        case ZBWStoragePrivateTypeKeyChain:
            string = @"ZBWKeyChainStorage";
            break;
        case ZBWStoragePrivateTypeArchiver:
            string = @"ZBWArchiverStorage";
            break;
        case ZBWStoragePrivateTypeMemoryOnly:
            string = @"ZBWMemoryStorage";
            break;
        case ZBWStoragePrivateTypeMemoryAndArchiver:
            string = @"ZBWMemoryAndArchiveStorage";
            break;
        default:
            NSAssert(NO, ([NSString stringWithFormat:@"[ZBWStorageFactory createStorageByType:], case语句漏了type:%ld", type]));
            break;
    }
    if (!string) {
        return nil;
    }
    Class aClass = NSClassFromString(string);
    if (!aClass) {
        return nil;
    }
    
    if (!class_conformsToProtocol(aClass, @protocol(ZBWStorageInterface))) {
        return nil;
    }
    
    Class supClass = class_getSuperclass(aClass);
    while (supClass) {
        if (supClass == NSClassFromString(@"ZBWStorage")) {
            break;
        }
        supClass = class_getSuperclass(supClass);
        if (!supClass || supClass == [NSObject class]) {
            return nil;
        }
    }
  
    return [[aClass alloc] init];
}

@end
