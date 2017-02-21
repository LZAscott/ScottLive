//
//  ScottHotViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottHotViewController.h"
#import "ScottLiveCell.h"
#import "ScottNetworkTool.h"
#import "ScottLiveModel.h"
#import "MJExtension.h"
#import "ScottRefreshView.h"
#import "SVProgressHUD.h"
#import "ScottPageView.h"
#import "UIScreen+ScottExtension.h"
#import "ScottBannerModel.h"
#import "ScottCrownViewController.h"
#import "ScottLivingCollectionController.h"

@interface ScottHotViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *bannerArray;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) ScottPageView *bannerView;


@end

@implementation ScottHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviBarView.hidden = YES;
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 465;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ScottLiveCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ScottLiveCell class])];
    self.currentPage = 1;
    
    self.tableView.mj_header = [ScottRefreshView headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        self.currentPage = 1;
        [self loadBannerData];
        [self loadHotLiveData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage += 1;
        [self loadBannerData];
        [self loadHotLiveData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableHeaderView = self.bannerView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)loadHotLiveData {
    NSString *url = [NSString stringWithFormat:@"Fans/GetHotLive?page=%ld",(long)self.currentPage];
    [[ScottNetworkTool shareTools] requestWithMethod:GET andURLString:url parameters:nil finishCallBack:^(id result, NSError *error) {
        if (!error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            NSArray *resultArr = [ScottLiveModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
            
            if (resultArr.count != 0) {    // 有数据
                [self.dataArray addObjectsFromArray:resultArr];
                [self.tableView reloadData];
            }else{  // 无数据
                self.currentPage -= 1;
                [SVProgressHUD showErrorWithStatus:@"啊哦，没有更多的数据了!"];
            }
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.currentPage -- ;
            [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        }
    }];
}

- (void)loadBannerData {

    [[ScottNetworkTool shareTools] requestWithMethod:GET andURLString:@"Living/GetAD" parameters:nil finishCallBack:^(id result, NSError *error) {
        if (!error) {
            self.bannerArray = [ScottBannerModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            [self refreshBannerView];
        }else{
            [SVProgressHUD showErrorWithStatus:@"banner数据加载失败"];
        }
    }];
}

- (void)refreshBannerView {
    NSMutableArray *mArray = @[].mutableCopy;
    for (ScottBannerModel *model in self.bannerArray) {
        [mArray addObject:model.imageUrl];
    }
    self.bannerView.imageArr = mArray;
    
    __weak typeof(self) weakSelf = self;
    self.bannerView.imageClickBlock = ^(NSInteger index){
        ScottBannerModel *model = weakSelf.bannerArray[index];
        ScottCrownViewController *crownVC = [ScottCrownViewController new];
        crownVC.titleLabel.text = model.title;
        crownVC.urlStr = model.link;
        [weakSelf.navigationController pushViewController:crownVC animated:YES];
    };
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScottLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ScottLiveCell class])];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScottLivingCollectionController *livingVC = [[ScottLivingCollectionController alloc] init];
    livingVC.lives = self.dataArray;
    livingVC.currentIndex = indexPath.row;
    livingVC.naviBarView.hidden = YES;
    [self presentViewController:livingVC animated:YES completion:nil];
}


#pragma mark - lazy
- (NSMutableArray *)dataArray {
    return _dataArray ? : (_dataArray = @[].mutableCopy);
}

- (ScottPageView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[ScottPageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen scott_screenWidth], 100)];
    }
    return _bannerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
