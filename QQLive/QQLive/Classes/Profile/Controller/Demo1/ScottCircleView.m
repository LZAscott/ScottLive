//
//  ScottCircleView.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/30.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottCircleView.h"

@interface ScottCircleView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat rad;

@end

@implementation ScottCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)startAnimation {
    [self.layer addSublayer:self.shapeLayer];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkRun)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)displayLinkRun {
    NSLog(@"%.2f",self.rad);
    if (self.rad >= M_PI * 2) {   // 如果大于一圈，就停止定时器
        [self stopDisplayLink];
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetWidth(self.bounds)/2.0) radius:CGRectGetWidth(self.bounds)/2.0 startAngle:0 endAngle:self.rad clockwise:YES];
    
    self.shapeLayer.path = path.CGPath;
    
    self.rad += (M_PI * 2) / 180;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineWidth = 5.0f;
    }
    return _shapeLayer;
}

- (void)clearCircleLayer {
    self.rad = 0;
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    [self stopDisplayLink];
}

- (void)stopDisplayLink {
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
