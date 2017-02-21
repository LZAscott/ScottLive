//
//  ScottCountDown.m
//  QQLive
//
//  Created by bopeng on 2017/2/20.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "ScottCountDown.h"

NSString * const ScottNoticeMessage = @"活动已经结束！";

@interface ScottCountDown ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation ScottCountDown

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSTimeZone *localZone = [NSTimeZone localTimeZone];
        [self.dateFormatter setTimeZone:localZone];
    }
    return self;
}



/// 每秒执行一次
- (void)scott_countDownWithPER_SECBlock:(void (^)())PER_SECBlock {
    if (_timer==nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                PER_SECBlock();
            });
        });
        dispatch_resume(_timer);
    }
}


/**
 用NSDate日期倒计时

 @param startDate 开始日期
 @param endDate 结束日期
 @param completeBlock 回调block
 */
- (void)scott_countDownWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completeBlock:(countDownBlock)completeBlock {
    if (_timer == nil) {
        // 时间差（也就是需要倒计时的时间）
        NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
        
        __block int timeOut = timeInterval;
        if (timeOut != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            // 设置每秒执行
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
            
            dispatch_source_set_event_handler(_timer, ^{
                if (timeOut <= 0) { // 倒计时结束，关闭timer
                    [self scott_cancleTimer];
                    completeBlock(0,0,0,0);
                } else {
                    int days = (int)(timeOut / (3600 * 24));
                    int hours = (int)((timeOut - days * 24 * 3600) / 3600);
                    int minute = (int)(timeOut - days * 24 * 3600 - hours * 3600) / 60;
                    int second = timeOut - days * 24 * 3600 - hours * 3600 - minute * 60;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(days,hours,minute,second);
                    });
                    timeOut--;
                }
            });
            
            dispatch_resume(_timer);
        }
    }
}


/**
 用时间戳倒计时

 @param starTime 开始时间戳
 @param endTime 结束时间戳
 @param completeBlock 回调block
 */
- (void)scott_countDownWithStratTime:(long long)starTime endTime:(long long)endTime completeBlock:(countDownBlock)completeBlock {
    
    NSDate *startDate = [self scott_dateWithTimeInterval:starTime];
    NSDate *endDate = [self scott_dateWithTimeInterval:endTime];
    
    [self scott_countDownWithStartDate:startDate endDate:endDate completeBlock:completeBlock];
}


/**
 将时间戳转换成日期

 @param longlongValue 时间戳
 @return 日期
 */
- (NSDate *)scott_dateWithTimeInterval:(long long)longlongValue {
    long long value = longlongValue/1000;
    NSNumber *time = [NSNumber numberWithLongLong:value];
    //转换成NSTimeInterval
    NSTimeInterval nsTimeInterval = [time longValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}


- (NSString *)scott_getNowTimeWithString:(NSString *)tempString {
        
    // 截止时间date格式
    NSDate  *expireDate = [_dateFormatter dateFromString:tempString];
    NSDate  *nowDate = [NSDate date];
    
    // 当前时间字符串格式
    NSString *nowDateStr = [_dateFormatter stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [_dateFormatter dateFromString:nowDateStr];
    
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    
    int days = (int)(timeInterval / (3600 * 24));
    int hours = (int)((timeInterval - days * 24 * 3600) / 3600);
    int minutes = (int)(timeInterval - days * 24 * 3600 - hours * 3600) / 60;
    int seconds = timeInterval - days * 24 * 3600 - hours * 3600 - minutes * 60;
    
    if (hours <= 0 && minutes <= 0 && seconds <= 0) {
        return ScottNoticeMessage;
    }
    
    if (days > 0) {
        return [NSString stringWithFormat:@"%d天 %d小时 %02d分 %02d秒", days,hours,minutes,seconds];
    }
    
    return [NSString stringWithFormat:@"%d小时 %02d分 %02d秒",hours,minutes,seconds];
}


/// 销毁timer
- (void)scott_cancleTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}


- (void)dealloc {
    NSLog(@"ScottCountDown dealloc");
}

@end
