//
//  CustomActionSheet.m
//  QQLive
//
//  Created by Scott_Mr on 2016/12/3.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "CustomActionSheet.h"
#import "UIView+ScottAlertView.h"

@implementation CustomActionSheet

+ (instancetype)actionSheet {
    return [self createViewFromNib];
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

@end
