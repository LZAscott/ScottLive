//
//  ScottLivingEndView.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottLivingEndView.h"
#import "UIView+ScottFrame.h"

@interface ScottLivingEndView ()

@property (weak, nonatomic) IBOutlet UIButton *forcusBtn;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@property (weak, nonatomic) IBOutlet UIButton *lookOtherBtn;

@end

@implementation ScottLivingEndView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self maskRadius:self.quitBtn];
    [self maskRadius:self.lookOtherBtn];
    [self maskRadius:self.forcusBtn];
}


+ (instancetype)liveEndView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)maskRadius:(UIButton *)btn {
    btn.layer.cornerRadius = btn.scott_height * 0.5;
    btn.layer.masksToBounds = YES;
    if (btn != self.forcusBtn) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor purpleColor].CGColor;
    }
}

// 退出
- (IBAction)quitBtnClick:(UIButton *)sender {
    !self.closeBlock ? : self.closeBlock();
}

- (IBAction)forcusBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)lookOtherBtnClick:(UIButton *)sender {
    !self.lookOtherBlock ? : self.lookOtherBlock();
}

@end
