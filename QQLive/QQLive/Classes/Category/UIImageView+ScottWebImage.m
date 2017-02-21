//
//  UIImageView+ScottWebImage.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "UIImageView+ScottWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ScottExtension.h"

@implementation UIImageView (ScottWebImage)

- (void)scott_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder isAvatar:(BOOL)isAvatar {
    if (!url) {
        self.image = placeholder;
        return;
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (isAvatar) { // 如果是头像
            self.image = [image scott_avatarImageWithSize:self.bounds.size backColor:[UIColor whiteColor] lineColor:[UIColor lightGrayColor]];
        }
    }];
}

@end
