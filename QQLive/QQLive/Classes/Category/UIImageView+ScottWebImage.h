//
//  UIImageView+ScottWebImage.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ScottWebImage)

- (void)scott_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder isAvatar:(BOOL)isAvatar;

@end
