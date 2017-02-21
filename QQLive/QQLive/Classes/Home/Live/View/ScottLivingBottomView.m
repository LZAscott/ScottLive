//
//  ScottLivingBottomView.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottLivingBottomView.h"
#import "UIScreen+ScottExtension.h"

@interface ScottLivingBottomView ()

@property (nonatomic, strong) NSArray *imgArray;

@end

@implementation ScottLivingBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}



- (void)setupUI {
    CGFloat width = 40;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat margin = ([UIScreen scott_screenWidth] - self.imgArray.count * width) / (self.imgArray.count + 1);
    
    for (NSInteger i=0; i<self.imgArray.count; i++) {
        NSString *imgName = self.imgArray[i];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        x = margin + (margin + width) * i;
        imgView.frame = CGRectMake(x, y, width, width);
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)]];
        [self addSubview:imgView];
    }
}

- (void)imgClick:(UITapGestureRecognizer *)tap {
    !self.livBottomClickBlock ? : self.livBottomClickBlock(tap.view.tag);
}


#pragma mark - lazy
- (NSArray *)imgArray {
    if (!_imgArray) {
        _imgArray = @[@"talk_public_40x40", @"talk_private_40x40", @"talk_sendgift_40x40", @"talk_rank_40x40", @"talk_share_40x40", @"talk_close_40x40"];
    }
    return _imgArray;
}

@end
