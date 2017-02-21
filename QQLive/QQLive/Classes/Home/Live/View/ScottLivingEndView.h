//
//  ScottLivingEndView.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^lookOtherBlock)();
typedef void(^closeBlock)();

@interface ScottLivingEndView : UIView

+ (instancetype)liveEndView;

/// 观看其他主播
@property (nonatomic, copy) lookOtherBlock lookOtherBlock;
/// 退出
@property (nonatomic, copy) closeBlock  closeBlock;

@end
