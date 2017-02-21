//
//  UIView+ScottFrame.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ScottFrame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGPoint scott_origin;
@property (nonatomic, assign) CGSize scott_size;

@property (nonatomic) CGFloat scott_centerX;
@property (nonatomic) CGFloat scott_centerY;


@property (nonatomic) CGFloat scott_top;
@property (nonatomic) CGFloat scott_bottom;
@property (nonatomic) CGFloat scott_right;
@property (nonatomic) CGFloat scott_left;

@property (nonatomic) CGFloat scott_width;
@property (nonatomic) CGFloat scott_height;


/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)scott_drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
