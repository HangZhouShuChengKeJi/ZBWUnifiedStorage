//
//  ZBWStorageDomain.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/22.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWStorageDomain.h"
#import "ZBWUSDefine.h"
#import <CommonCrypto/CommonDigest.h>

@interface ZBWStorageDomain ()

@property (nonatomic, copy) NSString        *domain;
@property (nonatomic, copy) NSString        *diskPath;
@property (nonatomic, copy) NSString        *archiverDirPath;
@property (nonatomic, copy) NSString        *fileDirPath;

@property (nonatomic) dispatch_queue_t      ioQueue;
@property (nonatomic) NSFileManager         *fileManager;

@end

@implementation ZBWStorageDomain

- (instancetype)initWithDomain:(NSString *)domain
{
    if (self = [super init]) {
        self.domain = domain;
        self.isDefaultDomain = [self.domain isEqualToString:@"default"];
        self.diskPath = [self makeDiskCachePath:domain];
        ZBWUS_Log(@"域路径>>> %@",self.diskPath);
        self.archiverDirPath = [self.diskPath stringByAppendingPathComponent:@"archiver"];
        self.fileDirPath = [self.diskPath stringByAppendingPathComponent:@"file"];
        self.ioQueue = dispatch_queue_create("com.ZBWStorageDomain.io", DISPATCH_QUEUE_SERIAL);
        dispatch_sync(self.ioQueue, ^{
            self.fileManager = [NSFileManager new];
        });
    }
    return self;
}

- (NSString *)storageKeyForKey:(NSString *)key
{
    return [NSString stringWithFormat:@"_ZBWUS_%@_%@_",self.domain, key];
}

- (NSString *)archiverPathForKey:(NSString *)key
{
    NSString *md5Key = [self md5FileNameForKey:key];
    
    return [self.archiverDirPath stringByAppendingPathComponent:md5Key];
}


-(NSString *)makeDiskCachePath:(NSString*)fullNamespace{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *usPath = [paths[0] stringByAppendingPathComponent:@"_ZBWUnifiedStorage_"];
    return [usPath stringByAppendingPathComponent:fullNamespace];
}




- (void)storeData:(NSData *)data toFile:(NSString *)filePath
{
    if (!data) {
        return;
    }
    
    [self.fileManager createFileAtPath:filePath contents:data attributes:nil];
}


#pragma mark- Public Methods

- (void)storeDataInArchiverPath:(NSData *)data forKey:(NSString *)key
{
    if (!data || data.length == 0 || !key) {
        return;
    }
    
    dispatch_sync(self.ioQueue, ^{
        BOOL isDir = NO;
        if (![self.fileManager fileExistsAtPath:self.archiverDirPath isDirectory:&isDir] || !isDir) {
            NSError *error = nil;
            [self.fileManager createDirectoryAtPath:self.archiverDirPath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                ZBWUS_Log(@"%@文件夹创建失败", self.archiverDirPath);
            }
        }
        
        NSString *filePath = [self archiverPathForKey:key];
        
        [self.fileManager removeItemAtPath:filePath error:nil];
        [self.fileManager createFileAtPath:filePath contents:data attributes:nil];
    });
}


- (NSData *)dataInArchiverPath:(NSString *)key
{
    if (!key) {
        return nil;
    }
    __block NSData *data = nil;
    dispatch_sync(self.ioQueue, ^{
        NSString *filePath = [self archiverPathForKey:key];
        data = [NSData dataWithContentsOfFile:filePath];
    });
    
    return data;
}

- (void)removeArchiverPathForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    dispatch_sync(self.ioQueue, ^{
        NSString *filePath = [self archiverPathForKey:key];
        [self.fileManager removeItemAtPath:filePath error:nil];
    });
}

- (NSData *)dataInCacheFilePath:(NSString *)key
{
    return nil;
}

#pragma mark- tool Methods
// 对key进行md5，生成文件名
- (NSString *)md5FileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}
@end
