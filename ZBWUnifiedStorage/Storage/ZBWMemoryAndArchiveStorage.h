//
//  ZBWMemoryAndArchiveStorage.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/6/23.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWStorage.h"

/**
 *  内存和归档 存储器
 *  内存又系统NSCache管理，根据内存使用情况，决定是否释放； 释放的内存会自动归档；获取数据时，先从NSCache中获取，未获取到，则从归档文件中获取。
 */
@interface ZBWMemoryAndArchiveStorage : ZBWStorage <ZBWStorageInterface>

@end
