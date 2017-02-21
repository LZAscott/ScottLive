//
//  ScottMainTabBarController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottMainTabBarController.h"
#import "ScottHomeViewController.h"
#import "ScottShowViewController.h"
#import "ScottProfileViewController.h"
#import "ScottNavViewController.h"
#import "UIDevice+ScottExtension.h"
#import <AVFoundation/AVFoundation.h>
#import "ScottAlertViewController.h"
#import "ScottAlertView.h"

@interface ScottMainTabBarController ()<UITabBarControllerDelegate>

@end

@implementation ScottMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self addAllChildViewControllers];
    self.delegate = self;
}

- (void)addAllChildViewControllers {
    
    [self addOneChildController:[ScottHomeViewController new] andImageNamed:@"toolbar_home"];
    
    [self addOneChildController:[UIViewController new] andImageNamed:@"toolbar_live"];
    
    [self addOneChildController:[ScottProfileViewController new] andImageNamed:@"toolbar_me"];
}

- (void)addOneChildController:(UIViewController *)childVC andImageNamed:(NSString *)imgName {
    childVC.tabBarItem.image = [UIImage imageNamed:imgName];
    NSString *selectImageName = [NSString stringWithFormat:@"%@_sel",imgName];
    
    childVC.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    childVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    ScottNavViewController *navVC = [[ScottNavViewController alloc] initWithRootViewController:childVC];
    [self addChildViewController:navVC];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSArray *childVcArray = tabBarController.childViewControllers;
    if ([childVcArray indexOfObject:viewController] == 1) { // 点击个人直播
        // 判断是否是模拟器
        if ([[UIDevice currentDevice] scott_isSimulator]) {
            [self showNoticeMessage:@"请使用真机运行"];
            return NO;
        }
        
        // 判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [self showNoticeMessage:@"您的设备没有摄像头或者相关的驱动, 不能进行直播"];
            return NO;
        }
        
        // 判断是否有摄像头权限
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            [self showNoticeMessage:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
            return NO;
        }
        
        // 开启麦克风权限
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    return YES;
                } else {
                    [self showNoticeMessage:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                    return NO;
                }
            }];
        }
        
        ScottShowViewController *showVc = [[ScottShowViewController alloc] init];
        showVc.naviBarView.hidden = YES;
        [self presentViewController:showVc animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

- (void)showNoticeMessage:(NSString *)message {
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"提示" message:message];
    
    ScottAlertAction *action = [ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction * _Nonnull action) {
    }];
    [alertView addAction:action];
    
    ScottAlertViewController *alertViewController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    alertViewController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertViewController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
