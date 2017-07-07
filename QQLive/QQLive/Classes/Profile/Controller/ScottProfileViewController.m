//
//  ScottProfileViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottProfileViewController.h"
#import "ScottBaseViewController.h"
#import "ScottLayerViewController.h"
#import "Demo2ViewController.h"
#import "Demo3ViewController.h"
#import "Demo4ViewController.h"
#import "Demo5ViewController.h"
#import "Demo6ViewController.h"

static NSString *ScottProfileReuseIden = @"ScottProfileReuseIden";

@interface ScottProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation ScottProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"个人中心";
//    self.titleLabel.text = @"个人中心";
    self.navItem.title = @"个人中心";
    [self setupTableView];
}

- (void)setupTableView {
//    [self.view insertSubview:self.tableView belowSubview:self.naviBarView];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ScottProfileReuseIden];
}

#pragma mark - UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScottProfileReuseIden];
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ScottBaseViewController *baseVC;
    switch (indexPath.row) {
        case 0:{
            baseVC = [ScottLayerViewController new];
        }
            break;
        case 1:{
            baseVC = [[Demo2ViewController alloc] initWithNibName:NSStringFromClass([Demo2ViewController class]) bundle:nil];
        }
            break;
        case 2:{
            baseVC = [Demo3ViewController new];
        }break;
        case 3:{
            baseVC = [Demo4ViewController new];
        }break;
        case 4:{
            baseVC = [Demo5ViewController new];
        }break;
        case 5:{
            baseVC = [Demo6ViewController new];
        }
        default:
            break;
    }
    baseVC.navItem.title = self.titleArr[indexPath.row];
    [self.navigationController pushViewController:baseVC animated:YES];
}

#pragma mark - lazy
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"layer画圆动画",@"自定义alertView",@"点赞动画",@"popMenu",@"人脸识别",@"cell中倒计时"];
    }
    return _titleArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
