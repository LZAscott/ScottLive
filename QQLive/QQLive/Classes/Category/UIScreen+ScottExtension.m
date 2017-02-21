//
//  UIScreen+ScottExtension.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "UIScreen+ScottExtension.h"

@implementation UIScreen (ScottExtension)

+ (CGFloat)scott_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)scott_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)scott_screenScale {
    return [UIScreen mainScreen].scale;
}

+ (CGRect)scott_screenBounds {
    return [UIScreen mainScreen].bounds;
}


@end
