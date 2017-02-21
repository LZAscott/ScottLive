//
//  UIScreen+ScottExtension.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (ScottExtension)

/// 屏幕宽度
+ (CGFloat)scott_screenWidth;

/// 屏幕高度
+ (CGFloat)scott_screenHeight;

/// 屏幕分辨率
+ (CGFloat)scott_screenScale;

/// 屏幕bounds
+ (CGRect)scott_screenBounds;

@end
