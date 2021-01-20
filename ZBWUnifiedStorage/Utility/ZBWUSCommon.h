//
//  ZBWUSCommon.h
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/7/6.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBWUSDefine.h"

FOUNDATION_EXTERN NSDateFormatter *zbw_US_dateFormatter(void);

FOUNDATION_EXTERN NSDate * zbw_US_expirationDate(long expiration , ZBWTimeUnit unit ,ZBWTimeAccuracy accuracy);
