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

//+ (void)initialize {
//    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navBar_bg_414x70"] forBarMetrics:UIBarMetricsDefault];
//}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 去掉根控制器以及栈底控制器
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        if ([viewController isKindOfClass:[ScottBaseViewController class]]) {
            ScottBaseViewController *baseVC = (ScottBaseViewController *)viewController;
            UIButton *backBtn = [UIButton scott_imageButton:@"back_9x16" backgroundImageName:@""];
            [backBtn sizeToFit];
            [backBtn addTarget:self action:@selector(popToParent) forControlEvents:UIControlEventTouchUpInside];
            baseVC.leftView = backBtn;
        }
        
        // 如果自定义返回按钮后, 滑动返回可能失效, 需要添加下面的代码
//        __weak typeof(viewController)Weakself = viewController;
//        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
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
