//
//  ScottCountDown.h
//  QQLive
//
//  Created by Scott_Mr on 2017/2/20.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const ScottNoticeMessage;


typedef void(^countDownBlock)(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second);

@interface ScottCountDown : NSObject

/**
 用NSDate日期倒计时
 
 @param startDate 开始日期
 @param endDate 结束日期
 @param completeBlock 回调block
 */
- (void)scott_countDownWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate completeBlock:(countDownBlock)completeBlock;


/**
 用时间戳倒计时
 
 @param starTime 开始时间戳
 @param endTime 结束时间戳
 @param completeBlock 回调block
 */

- (void)scott_countDownWithStratTime:(long long)starTime endTime:(long long)endTime completeBlock:(countDownBlock)completeBlock;

/// 每秒走一次，回调block
- (void)scott_countDownWithPER_SECBlock:(void (^)())PER_SECBlock;



/**
 将时间格式化

 @param tempString 2017-01-02 14:16:43
 @return %d天 %d小时 %02d分 %02d秒
 */
- (NSString *)scott_getNowTimeWithString:(NSString *)tempString;


@end
