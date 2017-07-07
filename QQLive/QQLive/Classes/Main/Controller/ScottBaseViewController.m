//
//  ScottBaseViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottBaseViewController.h"
#import "UIScreen+ScottExtension.h"
#import <STNavigationBar/STNavigationBar.h>

@interface ScottBaseViewController ()

@end

@implementation ScottBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupCustomBar];
}

- (void)setupCustomBar {
    [self st_setCustomNavigationBar:self.navBar];
    [self st_setNavigationBarBarTintColor:[UIColor redColor]];
    
    [self.view addSubview:self.navBar];
    self.navBar.items = @[self.navItem];
    self.navBar.barTintColor = [UIColor redColor];
    self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.navBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.bounds), CGRectGetHeight(self.navigationController.navigationBar.bounds) + 20);
}

- (UINavigationBar *)navBar {
    if (_navBar == nil) {
        _navBar = [[UINavigationBar alloc] init];
    }
    return _navBar;
}

- (UINavigationItem *)navItem {
    if (_navItem == nil) {
        _navItem = [[UINavigationItem alloc] init];
    }
    return _navItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
