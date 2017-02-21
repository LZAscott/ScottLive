//
//  ScottLivingCollectionController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottLivingCollectionController.h"
#import "ScottLivingCollectionCell.h"
#import "UIScreen+ScottExtension.h"
#import "ScottRefreshView.h"

@interface ScottLivingCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation ScottLivingCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
}

- (void)setupCollectionView {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ScottLivingCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ScottLivingCollectionCell class])];
    
    ScottRefreshView *refreshView = [ScottRefreshView headerWithRefreshingBlock:^{
        [self.collectionView.mj_header endRefreshing];
        self.currentIndex++;
        if (self.currentIndex == self.lives.count) {
            self.currentIndex = 0;
        }
        [self.collectionView reloadData];
    }];
    
    refreshView.stateLabel.hidden = NO;
    [refreshView setTitle:@"下拉切换另一个主播" forState:MJRefreshStatePulling];
    [refreshView setTitle:@"下拉切换另一个主播" forState:MJRefreshStateIdle];
    [refreshView setTitle:@"正在切换另一个主播" forState:MJRefreshStateRefreshing];
    self.collectionView.mj_header = refreshView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScottLivingCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ScottLivingCollectionCell class]) forIndexPath:indexPath];
    
    cell.parentVC = self;
    
    cell.live = self.lives[self.currentIndex];
    NSUInteger relateIndex = self.currentIndex;
    
    if (self.currentIndex + 1 == self.lives.count) {
        relateIndex = 0;
    }else{
        relateIndex += 1;
    }
    cell.relateLive = self.lives[relateIndex];
    
    cell.clickCatViewBlock = ^(){
        self.currentIndex += 1;
        [collectionView reloadData];
    };

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}



@end
