//
//  ZBWUSCommon.m
//  ZBWUnifiedStorage
//
//  Created by Bowen on 16/7/6.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWUSCommon.h"

NSDateFormatter *zbw_US_dateFormatter()
{
    NSThread *currentThread = [NSThread currentThread];
    NSDateFormatter *dateFormatter = [currentThread threadDictionary][@"__zbwUS_dateFormatter__"];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale systemLocale];
        dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [currentThread threadDictionary][@"__zbwUS_dateFormatter__"] = dateFormatter;
    }
    return dateFormatter;
}


NSDate * zbw_US_expirationDate(long expiration , ZBWTimeUnit unit ,ZBWTimeAccuracy accuracy)
{
    if (expiration <= 0) {
        return nil;
    }
    NSDate *now = [NSDate date];
    NSDate *expirationDate = [NSDate distantFuture];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendarUnit calendarUnit;
    switch (unit) {
        case ZBWTimeUnitSecond:
            calendarUnit = NSCalendarUnitSecond;
            dateComponents.second = expiration;
            break;
        case ZBWTimeUnitMinute:
            calendarUnit = NSCalendarUnitMinute;
            dateComponents.minute = expiration;
            break;
        case ZBWTimeUnitHour:
            calendarUnit = NSCalendarUnitHour;
            dateComponents.hour = expiration;
            break;
        case ZBWTimeUnitDay:
            calendarUnit = NSCalendarUnitDay;
            dateComponents.day = expiration;
            break;
        case ZBWTimeUnitMonth:
            calendarUnit = NSCalendarUnitMonth;
            dateComponents.month = expiration;
            break;
        case ZBWTimeUnitYear:
            calendarUnit = NSCalendarUnitYear;
            dateComponents.year = expiration;
            break;
            
        default:
            calendarUnit = NSCalendarUnitSecond;
            dateComponents.second = expiration;
            break;
    }
    expirationDate = [calendar dateByAddingComponents:dateComponents toDate:now options:0];
    if (accuracy) {
        NSDateFormatter *dateFormatter = zbw_US_dateFormatter();
        NSString *expirationDateStr = [dateFormatter stringFromDate:expirationDate];
        if (expirationDateStr.length < dateFormatter.dateFormat.length) {
            return expirationDate;
        }
        switch (accuracy) {
            case ZBWTimeAccuracyDay:
                expirationDateStr = [expirationDateStr stringByReplacingCharactersInRange:NSMakeRange(@"yyyy-MM-dd ".length, @"HH:mm:ss".length) withString:@"00:00:00"];
                break;
            case ZBWTimeAccuracyMonth:
                expirationDateStr = [expirationDateStr stringByReplacingCharactersInRange:NSMakeRange(@"yyyy-MM-".length, @"dd HH:mm:ss".length) withString:@"01 00:00:00"];
                break;
            default:
                break;
        }
        expirationDate = [dateFormatter dateFromString:expirationDateStr];
    }
    
    return expirationDate;
}
