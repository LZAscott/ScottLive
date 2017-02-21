//
//  ScottBaseViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottBaseViewController.h"
#import "UIScreen+ScottExtension.h"

@interface ScottBaseViewController ()

@end

@implementation ScottBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.naviBarView];
    [self.naviBarView addSubview:self.titleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.naviBarView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.naviBarView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:10];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.naviBarView attribute:NSLayoutAttributeWidth multiplier:1 constant:-100];
    
    [self.naviBarView addConstraint:centerX];
    [self.naviBarView addConstraint:centerY];
    [self.naviBarView addConstraint:width];
}

- (void)setLeftView:(UIView *)leftView {
    if (leftView == nil) return;
    
    [self.naviBarView addSubview:leftView];
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.naviBarView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.naviBarView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:10];
    
    [self.naviBarView addConstraint:left];
    [self.naviBarView addConstraint:centerY];
}

- (void)setRightView:(UIView *)rightView {
    if (rightView == nil) return;
    
    [self.naviBarView addSubview:rightView];
    rightView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.naviBarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
     NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.naviBarView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:10];
    [self.naviBarView addConstraint:right];
    [self.naviBarView addConstraint:centerY];
}

- (UIView *)naviBarView {
    if (!_naviBarView) {
        
        _naviBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen scott_screenWidth], 64.0)];
        _naviBarView.backgroundColor = [UIColor redColor];
    }
    return _naviBarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
