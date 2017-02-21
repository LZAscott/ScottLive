//
//  UIView+ScottRuntime.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "UIView+ScottRuntime.h"
#import <objc/message.h>

@implementation UIView (ScottRuntime)

/// 查找视图 KEY
const char *SCOTT_FIND_VIEW_KEY;

#pragma mark - 查找子视图
+ (UIView *)findView {
    return objc_getAssociatedObject(self, SCOTT_FIND_VIEW_KEY);
}

+ (void)setFindView:(UIView *)findView {
    objc_setAssociatedObject(self, SCOTT_FIND_VIEW_KEY, findView, OBJC_ASSOCIATION_ASSIGN);
}

+ (UIView *)scott_firstInView:(UIView *)view clazzName:(NSString *)clazzName {
    
    // 递归出口
    if ([self.findView isKindOfClass:NSClassFromString(clazzName)]) {
        return self.findView;
    }
    
    // 遍历所有子视图
    for (UIView *subView in view.subviews) {
        
        // 如果是要查找的类，记录并且返回
        if ([subView isKindOfClass:NSClassFromString(clazzName)]) {
            self.findView = subView;
            break;
        } else {
            // 使用子视图递归调用
            [self scott_firstInView:subView clazzName:clazzName];
        }
    }
    
    return self.findView;
}

/// 遍历当前视图的成员变量 - 仅供测试使用
- (void)scott_ivarsList {
    
    uint32_t count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    for (UInt32 i=0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *cName = ivar_getName(ivar);
        NSString *name = [[NSString alloc] initWithUTF8String:cName];
        NSLog(@"%@",name);
    }
}



@end
