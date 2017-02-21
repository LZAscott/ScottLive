//
//  ScottLivingTopView.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/28.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottLivingTopView.h"
#import "UIView+ScottFrame.h"
#import "UIImage+ScottExtension.h"
#import "ScottUserModel.h"
#import "MJExtension.h"
#import "UIImageView+ScottWebImage.h"
#import "ScottLiveModel.h"

@interface ScottLivingTopView ()

@property (weak, nonatomic) IBOutlet UIView *mainDetailView;

@property (weak, nonatomic) IBOutlet UIButton *giftBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *otherPersonScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headImv;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;

/// 守护
@property (nonatomic, strong) NSArray *userArray;


@end

@implementation ScottLivingTopView


+ (instancetype)livingTopView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    [self maskViewToBounds:self.mainDetailView];
    [self maskViewToBounds:self.headImv];
    [self maskViewToBounds:self.stateBtn];
    [self maskViewToBounds:self.giftBtn];
    
    self.headImv.layer.borderWidth = 1;
    self.headImv.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.stateBtn setBackgroundImage:[UIImage scott_imageWithColor:[UIColor redColor] size:self.stateBtn.bounds.size] forState:UIControlStateNormal];
    
    [self.stateBtn setBackgroundImage:[UIImage scott_imageWithColor:[UIColor lightGrayColor] size:self.stateBtn.bounds.size] forState:UIControlStateSelected];
    [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self setupOtherPeopleScrollView];
}

- (void)setupOtherPeopleScrollView {
    CGFloat defaultMargin = 10;
    CGFloat width = self.otherPersonScrollView.scott_height - defaultMargin;
    self.otherPersonScrollView.contentSize = CGSizeMake((width+defaultMargin) * self.userArray.count + defaultMargin, 0);
    
    CGFloat x = 0;
    for (NSInteger i=0; i<self.userArray.count; i++) {
        x = (defaultMargin + width) * i;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, width, width)];
        [self maskViewToBounds:imgView];
        ScottUserModel *model = self.userArray[i];
        [imgView scott_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:nil isAvatar:YES];
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImvDidClick:)]];
        [self.otherPersonScrollView addSubview:imgView];
    }
}

- (void)userImvDidClick:(UITapGestureRecognizer *)tap {
    NSLog(@"点击了头像");
}

- (void)maskViewToBounds:(UIView *)view {
    view.layer.cornerRadius = view.scott_height * 0.5;
    view.layer.masksToBounds = YES;
}

- (void)setLiveModel:(ScottLiveModel *)liveModel {
    _liveModel = liveModel;
    
    [self.headImv scott_setImageWithURL:[NSURL URLWithString:liveModel.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] isAvatar:YES];
    self.nameLabel.text = liveModel.myname;
    self.peopleCountLabel.text = [NSString stringWithFormat:@"%ld人",(unsigned long)liveModel.allnum];
    
    self.headImv.userInteractionEnabled = YES;
    [self.headImv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userImvDidClick:)]];
}


- (IBAction)stateBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - lazy
- (NSArray *)userArray {
    if (!_userArray) {
        NSArray *resultArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]];
        _userArray = [ScottUserModel mj_objectArrayWithKeyValuesArray:resultArr];
    }
    return _userArray;
}

@end
