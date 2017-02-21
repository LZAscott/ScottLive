//
//  CustomAlertView.m
//  QQLive
//
//  Created by Scott_Mr on 2016/12/3.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIView+ScottAlertView.h"

@implementation CustomAlertView

+ (instancetype)alertView {
    return [self createViewFromNib];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismiss];
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

@end
