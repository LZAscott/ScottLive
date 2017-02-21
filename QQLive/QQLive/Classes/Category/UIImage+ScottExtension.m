//
//  UIImage+ScottExtension.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "UIImage+ScottExtension.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (ScottExtension)

/// 获取屏幕截图
///
/// @return 屏幕截图图像
+ (UIImage *)scott_screenShot {
    // 1. 获取到窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // 2. 开始上下文
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 0);
    
    // 3. 将 window 中的内容绘制输出到当前上下文
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
    
    // 4. 获取图片
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5. 关闭上下文
    UIGraphicsEndImageContext();
    
    return screenShot;
}

+ (UIImage *)scott_blurImage:(UIImage *)image blur:(CGFloat)blur {
    // 模糊度越界
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL){
        NSLog(@"No pixelbuffer");
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (UIImage *)scott_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (color) {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
    }
    return nil;
}

+ (UIImage *)circleImageWithOriginImage:(UIImage *)originImage
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor {
    // 1.获取原图大小
    CGSize originSize = originImage.size;
    
    // 2.加上边框之后图片的大小
    CGFloat imageW = originSize.width + 2 * borderWidth;
    CGFloat imageH = originSize.width + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    
    // 3.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    
    // 4.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 5.画大圆
    [borderColor set];
    CGFloat bigRadius = imageSize.width * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 6.小圆
    CGFloat smallRadius = originSize.width * 0.5;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 7.画图
    [originImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    // 8.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 9.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)scott_avatarImageWithSize:(CGSize)size backColor:(UIColor *)color lineColor:(UIColor *)lineColor {
    if (color == nil) {
        color = [UIColor whiteColor];
    }
    if (lineColor == nil) {
        lineColor = [UIColor lightGrayColor];
    }
    
    CGSize originSize = size;
    if (originSize.width == 0) {
        originSize = CGSizeMake(34, 34);
    }
    
    CGRect rect = CGRectMake(0, 0, originSize.width, originSize.height);

    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    [color setFill];
    UIRectFill(rect);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];

    [self drawInRect:rect];
    
    UIBezierPath *ovalInPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    ovalInPath.lineWidth = 1;
    [lineColor setStroke];
    [ovalInPath stroke];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
