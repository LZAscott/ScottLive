//
//  Demo6ViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2017/2/20.
//  Copyright © 2017年 Scott. All rights reserved.
//

#import "Demo6ViewController.h"
#import "ScottCountDown.h"
#import "Demo6Cell.h"

static NSString *ScottDemo6Cell = @"ScottDemo6Cell";

@interface Demo6ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) ScottCountDown *countDown;



@end

@implementation Demo6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _dataSource = @[@"2017-01-02 14:16:43",@"2017-01-03 14:23:52",@"2017-01-04 14:29:45",@"2017-01-05 14:17:44",@"2017-01-06 14:23:53",@"2017-01-07 14:30:45",@"2017-01-08 14:18:45",@"2017-01-09 14:23:54",@"2017-01-10 14:31:01",@"2017-02-01 14:19:30",@"2017-02-02 14:23:55",@"2017-02-03 14:32:02",@"2017-02-04 14:20:31",@"2017-03-01 14:23:56",@"2017-03-02 14:33:03",@"2017-03-03 14:21:12",@"2017-03-07 14:23:45",@"2017-04-02 14:34:04",@"2017-04-03 14:23:32",@"2017-04-04 14:23:49",@"2017-04-05 14:04:05",@"2017-05-05 14:23:05",@"2017-06-02 14:24:09",@"2017-07-05 14:14:06"];
    
    self.countDown = [[ScottCountDown alloc] init];
    
    __weak __typeof(self) weakSelf= self;
    ///每秒回调一次
    [self.countDown scott_countDownWithPER_SECBlock:^{
        [weakSelf scott_updateTimeInVisibleCells];
    }];

    [_tableView registerNib:[UINib nibWithNibName:@"Demo6Cell" bundle:nil] forCellReuseIdentifier:ScottDemo6Cell];
    _tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0);
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = 74;
}

- (void)scott_updateTimeInVisibleCells {
    NSArray *cells = [_tableView visibleCells];
    for (Demo6Cell *cell in cells) {
        cell.countLabel.text = [self.countDown scott_getNowTimeWithString:_dataSource[cell.tag]];
        if ([cell.countLabel.text isEqualToString:ScottNoticeMessage]) {
            cell.countLabel.textColor = [UIColor redColor];
        }else{
            cell.countLabel.textColor = [UIColor greenColor];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Demo6Cell *cell = (Demo6Cell *)[tableView dequeueReusableCellWithIdentifier:ScottDemo6Cell];
    
    cell.tag = indexPath.row;
    
    cell.endTimeLabel.text = [NSString stringWithFormat:@"活动 %@ 结束", _dataSource[indexPath.row]];
    cell.countLabel.text = [self.countDown scott_getNowTimeWithString:_dataSource[indexPath.row]];
    if ([cell.countLabel.text isEqualToString:ScottNoticeMessage]) {
        cell.countLabel.textColor = [UIColor redColor];
    }else{
        cell.countLabel.textColor = [UIColor greenColor];
    }
    
    return cell;
}

- (void)dealloc{
    NSLog(@"demo6 dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
