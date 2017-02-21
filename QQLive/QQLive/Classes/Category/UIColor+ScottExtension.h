//
//  UIColor+ScottExtension.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ScottExtension)

+ (UIColor *)scott_colorWithHex:(uint32_t)hex;

+ (UIColor *)scott_randomColor;

+ (UIColor *)scott_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;

/// 将16进制颜色值转换成RGB对应的颜色
+ (UIColor *)scott_colorWithHexString:(NSString *)hexString;


@end
