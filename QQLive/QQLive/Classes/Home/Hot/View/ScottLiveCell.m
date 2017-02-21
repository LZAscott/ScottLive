//
//  ScottLiveCell.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottLiveCell.h"
#import "ScottLiveModel.h"
#import "UIImageView+ScottWebImage.h"

@interface ScottLiveCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImv;

@property (weak, nonatomic) IBOutlet UIImageView *starImv;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImv;
@property (weak, nonatomic) IBOutlet UIImageView *livingImv;

@end

@implementation ScottLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];
}

- (void)setModel:(ScottLiveModel *)model {

    _model = model;
    
    // 设置头像
    NSURL *imageUrl = [NSURL URLWithString:model.smallpic];
    [self.headImv scott_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_head"] isAvatar:YES];
    
    // 直播名
    self.nameLabel.text = model.myname;
    
    // 地址
    if (!model.gps.length) {
        model.gps = @"难道在火星?";
    }
    [self.addressBtn setTitle:model.gps forState:UIControlStateNormal];
    
    // 设置大图
    [self.bgImv scott_setImageWithURL:[NSURL URLWithString:model.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"] isAvatar:NO];
    
    // 直播状态
    self.starImv.image = [UIImage imageNamed:[NSString stringWithFormat:@"girl_star%ld_40x19", (unsigned long)model.starlevel]];
    self.starImv.hidden = !model.starlevel;

    // 设置当前观众数量
    NSString *fullChaoyang = [NSString stringWithFormat:@"%ld人在看", (unsigned long)model.allnum];
    NSRange range = [fullChaoyang rangeOfString:[NSString stringWithFormat:@"%ld", (unsigned long)model.allnum]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullChaoyang];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.peopleCountLabel.attributedText = attr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
