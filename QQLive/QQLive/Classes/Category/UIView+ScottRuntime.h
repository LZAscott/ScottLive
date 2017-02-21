//
//  UIView+ScottRuntime.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ScottRuntime)

/// 查找子视图
///
/// @param view      要查找的视图
/// @param clazzName 子控件类名
///
/// @return 找到的第一个子视图
+ (UIView *)scott_firstInView:(UIView *)view clazzName:(NSString *)clazzName;


/// 遍历当前视图的成员变量 - 仅供测试使用
- (void)scott_ivarsList;

@end
