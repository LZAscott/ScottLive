//
//  Demo3ViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/30.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "Demo3ViewController.h"
#import "ScottZanButton.h"

@interface Demo3ViewController ()

@end

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ScottZanButton *zanBtn = [[ScottZanButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    zanBtn.center = self.view.center;
    [self.view addSubview:zanBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
