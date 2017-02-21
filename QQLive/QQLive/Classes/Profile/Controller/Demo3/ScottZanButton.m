//
//  ScottZanButton.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/30.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottZanButton.h"

@interface ScottZanButton ()

@property (nonatomic, strong) CAEmitterLayer *effectLayer;
@property (nonatomic, strong) CAEmitterCell *effectCell;
@property (nonatomic, strong) UIImage *zanImage;
@property (nonatomic, strong) UIImage *unZanImage;

@end

@implementation ScottZanButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _zanImage = [UIImage imageNamed:@"zan"];
        _unZanImage = [UIImage imageNamed:@"un_zan"];
        [self initBaseLayout];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _zanImage = [UIImage imageNamed:@"zan"];
        _unZanImage = [UIImage imageNamed:@"un_zan"];
        [self initBaseLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andZanImage:(UIImage *)zan andUnZanImage:(UIImage *)unZan {
    if (self = [super initWithFrame:frame]) {
        _zanImage = zan;
        _unZanImage = unZan;
        [self initBaseLayout];
    }
    return self;
}

- (void)initBaseLayout {
    _effectLayer=[CAEmitterLayer layer];
    [_effectLayer setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self.layer addSublayer:_effectLayer];
    [_effectLayer setEmitterShape:kCAEmitterLayerCircle];
    [_effectLayer setEmitterMode:kCAEmitterLayerOutline];
    [_effectLayer setEmitterPosition:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2)];
    [_effectLayer setEmitterSize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    _effectCell=[CAEmitterCell emitterCell];
    [_effectCell setName:@"zanShape"];
    [_effectCell setContents:(__bridge id)[UIImage imageNamed:@"EffectImage"].CGImage];
    [_effectCell setAlphaSpeed:-1.0f];
    [_effectCell setLifetime:1.0f];
    [_effectCell setBirthRate:0];
    [_effectCell setVelocity:50];
    [_effectCell setVelocityRange:50];
    
    [_effectLayer setEmitterCells:@[_effectCell]];
    
    
    [self setImage:self.unZanImage forState:UIControlStateNormal];
    [self setImage:self.zanImage forState:UIControlStateSelected];
    [self addTarget:self action:@selector(zanAnimationPlay:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)zanAnimationPlay:(ScottZanButton *)btn {
    btn.selected = !btn.selected;
 
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
    }];
    
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        if (self.isSelected) {
            CABasicAnimation *effectLayerAnimation=[CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
            [effectLayerAnimation setFromValue:[NSNumber numberWithFloat:100]];
            [effectLayerAnimation setToValue:[NSNumber numberWithFloat:0]];
            [effectLayerAnimation setDuration:0.0f];
            [effectLayerAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [_effectLayer addAnimation:effectLayerAnimation forKey:@"ZanCount"];
        }
    } completion:^(BOOL finished) {
        
    }];

}

@end
