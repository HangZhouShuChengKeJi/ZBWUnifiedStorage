//
//  ZBWMemoryStorage.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/23.
//
//

#import "ZBWMemoryStorage.h"
#import "ZBWStorageObject.h"
#import <UIKit/UIKit.h>

@interface ZBWMemoryStorage ()

@property (nonatomic) NSMutableDictionary       *cache;
@property (nonatomic) dispatch_queue_t          queue;

@end

@implementation ZBWMemoryStorage

- (instancetype)init
{
    if (self = [super init]) {
        self.queue = dispatch_queue_create("com.ZBWMemoryStorage.queue", DISPATCH_QUEUE_SERIAL);
        _cache = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)clearMemory {
    dispatch_async(self.queue, ^{
        [self.cache.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *key = obj;
            ZBWStorageObject *object = self.cache[key];
            if ([object hasExpired]) {
                [self.cache removeObjectForKey:key];
            }
        }];
    });
}


#pragma mark- ZBWStorageInterface

- (ZBWStorageObject *)storageObjectForKey:(NSString *)key
{
    __block ZBWStorageObject *object = nil;
    dispatch_sync(self.queue, ^{
        object = self.cache[key];
    });
    return object;
}

- (void)saveStorageObject:(ZBWStorageObject *)object
{
    dispatch_async(self.queue, ^{
        [self.cache setObject:object forKey:object.key];
    });    
}

- (void)removeStorageObjectForKey:(NSString *)key
{
    dispatch_async(self.queue, ^{
        [self.cache removeObjectForKey:key];
    });
}

@end
