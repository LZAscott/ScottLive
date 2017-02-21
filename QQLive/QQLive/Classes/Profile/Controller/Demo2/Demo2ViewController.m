//
//  Demo2ViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/12/2.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "Demo2ViewController.h"
#import "ScottAlertController.h"
#import "CustomAlertView.h"
#import "CustomActionSheet.h"
#import "UIImage+ScottExtension.h"

@interface Demo2ViewController ()

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/// 默认形式的alertView
- (IBAction)defaultAlertViewClick:(UIButton *)sender {
    
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"ScottAlertView" message:@"这是一段描述文字这是一段描述文字这是一段描述文字这是一段描述文字这是一段描述文字这是一段描述文字."];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        
    }]];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        
    }]];
    
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleDropDown];
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];

}

/// 自定义形式的alertView
- (IBAction)customAlertViewClick:(UIButton *)sender {
    CustomAlertView *alertView = [CustomAlertView alertView];
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/// 模糊背景的alertView
- (IBAction)effecBgAlertViewClick:(UIButton *)sender {
    UIImage *img = [UIImage scott_screenShot];
    img = [UIImage scott_blurImage:img blur:0.4];
    
    CustomAlertView *alertView = [CustomAlertView alertView];
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.userInteractionEnabled = YES;
    alertController.backgroundView = imgView;
    
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 带有textfield形式的alertView
- (IBAction)textfieldAlertViewClick:(UIButton *)sender {
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"ScottAlertView" message:@"This is a message, the alert view containt text and textfiled. "];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
    // 弱引用alertView 否则 会循环引用
    __weak typeof(alertView) weakAlertView = alertView;
    [alertView addAction:[ScottAlertAction actionWithTitle:@"确定" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        
        NSLog(@"%@",action.title);
        for (UITextField *textField in weakAlertView.textFieldArray) {
            NSLog(@"%@",textField.text);
        }
    }]];
    
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入账号";
    }];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入密码";
    }];
    
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleScaleFade];
    alertController.tapBackgroundDismissEnable = YES;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 默认形式的actionSheet
- (IBAction)defaultActionSheetClick:(UIButton *)sender {
    ScottAlertView *alertView = [ScottAlertView alertViewWithTitle:@"ScottActionSheet" message:@"This is a message, the alert view style is actionsheet. "];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"默认1" style:ScottAlertActionStyleDefault handler:^(ScottAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
    [alertView addAction:[ScottAlertAction actionWithTitle:@"删除" style:ScottAlertActionStyleDestructive handler:^(ScottAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    [alertView addAction:[ScottAlertAction actionWithTitle:@"取消" style:ScottAlertActionStyleCancel handler:^(ScottAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleActionSheet];
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 自定义形式的actionSheet
- (IBAction)customActionSheetClick:(UIButton *)sender {
    CustomActionSheet *alertView = [CustomActionSheet actionSheet];
    
    
    
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:alertView preferredStyle:ScottAlertControllerStyleActionSheet transitionAnimationStyle:ScottAlertTransitionStyleFade];
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
