//
//  NSDate+ScottExtension.m
//  QQLive
//
//  Created by Scott_Mr on 2016/12/2.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "NSDate+ScottExtension.h"

@implementation NSDate (ScottExtension)

- (NSString *)scott_dateDescription {
    // 1. 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 2. 判断是否是今天
    if ([calendar isDateInToday:self]) {
        
        NSInteger interval = ABS((NSInteger)[self timeIntervalSinceNow]);
        
        if (interval < 60) {
            return @"刚刚";
        }
        interval /= 60;
        if (interval < 60) {
            return [NSString stringWithFormat:@"%zd 分钟前", interval];
        }
        
        return [NSString stringWithFormat:@"%zd 小时前", interval / 60];
    }
    
    // 3. 昨天
    NSMutableString *formatString = [NSMutableString stringWithString:@" HH:mm"];
    if ([calendar isDateInYesterday:self]) {
        [formatString insertString:@"昨天" atIndex:0];
    } else {
        [formatString insertString:@"MM-dd" atIndex:0];
        
        // 4. 是否当年
        NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];
        
        if (components.year != 0) {
            [formatString insertString:@"yyyy-" atIndex:0];
        }
    }
    
    // 5. 转换格式字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    fmt.dateFormat = formatString;
    
    return [fmt stringFromDate:self];
}

- (NSDate *)scott_dateWithStr:(NSString *)str {
    // 1.1创建formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 1.2设置时间的格式
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";
    
    // 1.3设置时间的区域(真机必须设置，否则可能转换不成功)
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    
    // 1.4转换字符串, 转换好的时间是去除时区的时间
    NSDate *createDate = [formatter dateFromString:str];
    
    return createDate;
}

@end
