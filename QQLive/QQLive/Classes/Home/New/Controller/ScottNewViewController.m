//
//  ScottNewViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottNewViewController.h"
#import "ScottNetworkTool.h"
#import "ScottNewCollectionCell.h"
#import "ScottRefreshView.h"
#import "SVProgressHUD.h"
#import "ScottUserModel.h"
#import "UIScreen+ScottExtension.h"
#import "MJExtension.h"

@interface ScottNewViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataArray;

/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;

@end

@interface ScottNewViewController ()

@end

@implementation ScottNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviBarView.hidden = YES;
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 首先自动刷新一次
    [self autoRefresh];
    // 然后开启每一分钟自动更新
    _timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(autoRefresh) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)autoRefresh {
    [self.collectionView.mj_footer beginRefreshing];
}

- (void)setupCollectionView {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ScottNewCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ScottNewCollectionCell class])];
    
    self.currentPage = 1;
    
    self.collectionView.mj_header = [ScottRefreshView headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        self.currentPage = 1;
    
        [self loadData];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage += 1;
        [self loadData];
    }];
}

- (void)loadData {
    
    NSString *url = [NSString stringWithFormat:@"Room/GetNewRoomOnline?page=%ld", (long)self.currentPage];
    [[ScottNetworkTool shareTools] requestWithMethod:GET andURLString:url parameters:nil finishCallBack:^(id result, NSError *error) {
        if (!error) {
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            if (![result[@"msg"] isEqualToString:@"fail"]) {
                NSArray *resultArr = [ScottUserModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"list"]];
                
                if (resultArr.count != 0) {    // 有数据
                    [self.dataArray addObjectsFromArray:resultArr];
                }else{  // 无数据
                    self.currentPage -= 1;
                    [SVProgressHUD showErrorWithStatus:@"啊哦，没有更多的数据了!"];
                }
                [self.collectionView reloadData];
            }else{
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                [SVProgressHUD showErrorWithStatus:@"啊哦，没有更多的数据了!"];
                // 恢复当前页
                self.currentPage--;

            }
        }else{
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            self.currentPage -- ;
            [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld",(unsigned long)self.dataArray.count);
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScottNewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ScottNewCollectionCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([UIScreen scott_screenWidth] - 3) / 3.0;
    return CGSizeMake(width, width);
}

#pragma mark - lazy
- (NSMutableArray *)dataArray {
    return _dataArray ? : (_dataArray = @[].mutableCopy);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
