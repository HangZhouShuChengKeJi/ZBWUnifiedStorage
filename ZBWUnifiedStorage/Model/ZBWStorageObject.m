//
//  ZBWStorageObject.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/21.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWStorageObject.h"

@implementation ZBWStorageObject

+ (NSDictionary *)dictionary:(ZBWStorageObject *)object
{
    if (!object) {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    object.value ? dic[@"v"] = object.value : nil;
    object.expirationDate ? dic[@"e"] = object.expirationDate : nil;
#if DEBUG
    object.key ? dic[@"k"] = object.key : nil;
#endif
    
    return dic;
}

+ (ZBWStorageObject *)storageObjectWithDictionary:(NSDictionary *)dictionary
{
    ZBWStorageObject *obj = [[ZBWStorageObject alloc] init];
    obj.value = dictionary[@"v"];
    obj.expirationDate = dictionary[@"e"];
#if DEBUG
    obj.key = dictionary[@"k"];
#endif
    
    return obj;
}

+ (NSData *)data:(ZBWStorageObject *)object{
    return [NSKeyedArchiver archivedDataWithRootObject:object];
}

+ (ZBWStorageObject *)storageObjectWithData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


- (BOOL)hasExpired
{
    if (!_expirationDate) {
        return NO;
    }
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSinceDate:self.expirationDate];
    
    return interval > 0;
}

#pragma mark- NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (self.expirationDate) {
        [aCoder encodeObject:self.expirationDate forKey:@"expirationDate"];
    }
    if (self.value) {
        [aCoder encodeObject:self.value forKey:@"value"];
    }
#if DEBUG
    if (self.key) {
        [aCoder encodeObject:self.key forKey:@"key"];
    }
#endif
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.expirationDate = [aDecoder decodeObjectForKey:@"expirationDate"];
    self.value = [aDecoder decodeObjectForKey:@"value"];
#if DEBUG
    self.key = [aDecoder decodeObjectForKey:@"key"];
#endif
    
    return self;
}

@end
