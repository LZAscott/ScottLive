//
//  UIBarButtonItem+ScottExtension.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "UIBarButtonItem+ScottExtension.h"
#import "UIButton+ScottExtension.h"

@implementation UIBarButtonItem (ScottExtension)

- (instancetype)scott_initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action isBack:(BOOL)isBack {
    if (fontSize == 0) {
        fontSize = 16;
    }
    
    UIButton *btn = [UIButton scott_textButton:title fontSize:fontSize normalColor:[UIColor darkGrayColor] highlightedColor:[UIColor orangeColor]];

    if (isBack) {
        [btn setImage:[UIImage imageNamed:@"back_9x16"] forState:UIControlStateNormal];
        [btn sizeToFit];
    }
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [self initWithCustomView:btn];
}

@end
