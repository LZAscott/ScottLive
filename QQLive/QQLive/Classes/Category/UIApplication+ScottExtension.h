//
//  UIApplication+ScottExtension.h
//  QQLive
//
//  Created by Scott_Mr on 2016/12/5.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UIApplication (ScottExtension)

/// 返回应用程序代理
+ (AppDelegate *)scott_appDelegate;

/// 根视图控制器
+ (UIViewController *)scott_rootViewController;

/// 返回当前设备对应的启动图片
+ (UIImage *)scott_launchImage;

@end
