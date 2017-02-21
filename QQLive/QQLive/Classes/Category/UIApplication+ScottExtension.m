//
//  UIApplication+ScottExtension.m
//  QQLive
//
//  Created by Scott_Mr on 2016/12/5.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "UIApplication+ScottExtension.h"

@implementation UIApplication (ScottExtension)

/// 返回应用程序代理
+ (AppDelegate *)scott_appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

/// 根视图控制器
+ (UIViewController *)scott_rootViewController {
    return [UIApplication scott_appDelegate].window.rootViewController;
}

/// 返回当前设备对应的启动图片
+ (UIImage *)scott_launchImage {
    UIImage *image = nil;
    NSArray *launchImages = [NSBundle mainBundle].infoDictionary[@"UILaunchImages"];
    
    for (NSDictionary *dict in launchImages) {
        // 1. 将字符串转换成尺寸
        CGSize size = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        // 2. 与当前屏幕进行比较
        if (CGSizeEqualToSize(size, [UIScreen mainScreen].bounds.size)) {
            NSString *filename = dict[@"UILaunchImageName"];
            image = [UIImage imageNamed:filename];
            break;
        }
    }
    return image;
}

@end
