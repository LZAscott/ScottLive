//
//  UIViewController+ScottGif.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/28.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "UIViewController+ScottGif.h"
#import <objc/message.h>

static const void *gifKey = &gifKey;

@implementation UIViewController (ScottGif)

- (UIImageView *)gifView {
    return objc_getAssociatedObject(self, gifKey);
}

- (void)setGifView:(UIImageView *)gifView {
    objc_setAssociatedObject(self, gifKey, gifView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showLoading:(NSArray *)images inView:(UIView *)view {
    if (!images.count) {
        images = @[[UIImage imageNamed:@"hold1_60x72"], [UIImage imageNamed:@"hold2_60x72"], [UIImage imageNamed:@"hold3_60x72"]];
    }
    
    UIImageView *gifView = [[UIImageView alloc] init];
    
    if (!view) {
        view = self.view;
    }
    
    gifView.frame = CGRectMake(0, 0, 60, 70);
    gifView.center = view.center;
    [view addSubview:gifView];
    
    [self playGifAnimaWithImageView:gifView andImgs:images];
}

- (void)hiddenLoading {
    [self stopGifAnimaWithImageView:self.gifView];
    self.gifView = nil;
}

// 播放GIF
- (void)playGifAnimaWithImageView:(UIImageView *)imgView andImgs:(NSArray *)images {
    if (!images.count) {
        return;
    }
    //动画图片数组
    imgView.animationImages = images;
    //执行一次完整动画所需的时长
    imgView.animationDuration = 0.5;
    //动画重复次数, 设置成0 就是无限循环
    imgView.animationRepeatCount = 0;
    [imgView startAnimating];
}
// 停止动画
- (void)stopGifAnimaWithImageView:(UIImageView *)imgView {
    if (imgView.isAnimating) {
        [imgView stopAnimating];
    }
    [imgView removeFromSuperview];
}

@end
