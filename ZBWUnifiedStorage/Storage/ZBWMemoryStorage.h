//
//  ZBWMemoryStorage.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/23.
//
//

#import "ZBWStorage.h"

/**
 *  内存存储器
 *  常驻内存。使用NSMutableDictionary, 内存不会释放。
 */
@interface ZBWMemoryStorage : ZBWStorage<ZBWStorageInterface>

@end
