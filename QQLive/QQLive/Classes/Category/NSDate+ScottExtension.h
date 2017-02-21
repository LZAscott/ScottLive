//
//  NSDate+ScottExtension.h
//  QQLive
//
//  Created by Scott_Mr on 2016/12/2.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ScottExtension)

/**
 日期描述字符串

 格式如下：
    -   刚刚(一分钟内)
    -   x分钟前(一小时内)
    -   x小时前(当前)
    -   昨天 HH:mm(昨天)
    -   MM-dd HH:mm(一年内)
    -   yyyy-MM-dd HH:mm(更早期)
 */
- (NSString *)scott_dateDescription;


/**
 将服务器返回给我们的字符串转为NSDate

 @param str 时间字符串

 @return 格式化后的NSDate
 */
- (NSDate *)scott_dateWithStr:(NSString *)str;

@end
