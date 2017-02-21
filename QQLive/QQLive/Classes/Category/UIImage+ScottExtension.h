//
//  UIImage+ScottExtension.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScottExtension)

/// 获取屏幕截图
///
/// @return 屏幕截图图像
+ (UIImage *)scott_screenShot;


/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+ (UIImage *)scott_blurImage:(UIImage *)image blur:(CGFloat)blur;

/**
 *  根据颜色生成一张图片
 *
 *  @param color 颜色
 *  @param size  图片大小
 *
 *  @return 图片
 */
+ (UIImage *)scott_imageWithColor:(UIColor *)color size:(CGSize)size;



/**
 生成圆角图片

 @param originImage 原图(注意：宽高一定要相等，不然不会成为圆形)
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return 图片
 */
+ (UIImage *)circleImageWithOriginImage:(UIImage *)originImage
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor;


/**
 创建头像图像

 @param size 尺寸
 @param color 背景颜色
 @param lineColor 边框颜色
 @return 头像图像
 */
- (UIImage *)scott_avatarImageWithSize:(CGSize)size backColor:(UIColor *)color lineColor:(UIColor *)lineColor;



@end
