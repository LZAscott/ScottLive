//
//  UIViewController+ScottGif.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/28.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ScottGif)

@property (nonatomic, weak) UIImageView *gifView;


- (void)showLoading:(NSArray *)images inView:(UIView *)view;

- (void)hiddenLoading;


@end
