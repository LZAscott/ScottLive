//
//  ScottLayerViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/30.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottLayerViewController.h"
#import "ScottCircleView.h"

@interface ScottLayerViewController ()

@property (weak, nonatomic) IBOutlet ScottCircleView *circleView;

@end

@implementation ScottLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = nil;
    maskLayer.lineCap = kCALineCapRound;
    maskLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    maskLayer.lineWidth =2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(70, 100)];
    [path addLineToPoint:CGPointMake(80, 90)];
    [path addLineToPoint:CGPointMake(90, 100)];
//    maskLayer.hidden = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 100, 30)];
    label.text = @"试试文字";
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth = 1.0;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    maskLayer.path = path.CGPath;
    
    
    [self.view.layer addSublayer:maskLayer];
}

- (IBAction)startDrawCircle:(UIButton *)sender {
    [self.circleView startAnimation];
}

- (IBAction)cleanLayerClick:(UIButton *)sender {
    [self.circleView clearCircleLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
