//
//  ScottTextView.m
//  QQLive
//
//  Created by Scott_Mr on 2016/12/9.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottTextView.h"
#import "UIView+ScottFrame.h"
#import "UIScreen+ScottExtension.h"

@interface ScottTextView ()

@property (nonatomic,strong) UILabel *placehoderLabel;  // 占位label;

@end

@implementation ScottTextView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    
    // 1.添加占位label
    _placehoderLabel = [[UILabel alloc] init];
    
    // 2.设置占位label的属性
    _placehoderLabel.numberOfLines = 0;
    _placehoderLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_placehoderLabel];
    
    // 设置placehoder默认文字颜色
    self.placehoderColor = [UIColor grayColor];
    // 设置placehoder默认文字大小
    self.font = [UIFont systemFontOfSize:16];
    
    // 3.监听文字的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    _placehoderLabel.scott_top = 7.0f;   // 距上
    _placehoderLabel.scott_left = 5.0f;  // 距左
    _placehoderLabel.scott_width = [UIScreen scott_screenWidth] - 2 * _placehoderLabel.scott_left;
    
    // 根据文字的多少算高度
    CGSize maxSize = CGSizeMake(_placehoderLabel.scott_width, CGFLOAT_MAX);
    _placehoderLabel.scott_height = [_placehoder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_placehoderLabel.font} context:nil].size.height;
}

#pragma mark - 监听文字改变
- (void)textDidChange {
    // 只要一添加文字，_placehoderLabel就需要隐藏
    _placehoderLabel.hidden = (self.text.length != 0);
}

// 设置占位文字
- (void)setPlacehoder:(NSString *)placehoder {
    _placehoder = [placehoder copy];    // 使用copy
    
    _placehoderLabel.text = _placehoder;
    
    // 标记需要重新计算frame
    [self setNeedsLayout];
}

// 设置占位文字颜色
- (void)setPlacehoderColor:(UIColor *)placehoderColor {
    _placehoderColor = placehoderColor;
    _placehoderLabel.textColor = placehoderColor;
}

// 设置字体大小
- (void)setFont:(UIFont *)font {
    // 该属性是继承来的，所以要调用父类的方法
    [super setFont:font];
    _placehoderLabel.font = font;
    
    // 标记需要重新计算frame
    [self setNeedsLayout];
}

// 设置文字
- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange];
}


@end
