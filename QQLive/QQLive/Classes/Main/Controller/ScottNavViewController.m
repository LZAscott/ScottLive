//
//  ScottNavViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottNavViewController.h"
#import "UIBarButtonItem+ScottExtension.h"
#import "ScottBaseViewController.h"
#import "UIButton+ScottExtension.h"

@interface ScottNavViewController ()

@end

@implementation ScottNavViewController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 去掉根控制器以及栈底控制器
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        ScottBaseViewController *baseVC = (ScottBaseViewController *)viewController;
        baseVC.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] scott_initWithTitle:@"" fontSize:16 target:self action:@selector(popToParent) isBack:YES];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)popToParent {
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    self.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

@end
