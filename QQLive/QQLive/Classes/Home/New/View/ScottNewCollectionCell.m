//
//  ScottNewCollectionCell.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottNewCollectionCell.h"
#import "ScottUserModel.h"
#import "UIImageView+ScottWebImage.h"

@interface ScottNewCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImv;

@property (weak, nonatomic) IBOutlet UIImageView *stateImv;
@property (weak, nonatomic) IBOutlet UIButton *adressBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@end

@implementation ScottNewCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(ScottUserModel *)model {
    _model = model;
    
    // 设置封面头像
    [self.bgImv scott_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"] isAvatar:NO];

    
    // 地址
    [self.adressBtn setTitle:model.position forState:UIControlStateNormal];
    // 主播名
    self.nickLabel.text = model.nickname;
}

@end
