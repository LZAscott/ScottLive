//
//  ScottHomeViewController.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottHomeViewController.h"
#import "ScottHotViewController.h"
#import "ScottNewViewController.h"
#import "ScottCareViewController.h"
#import "HMSegmentedControl.h"
#import "UIScreen+ScottExtension.h"
#import "ScottCrownViewController.h"
#import "UIView+ScottFrame.h"


@interface ScottHomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentCtrl;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ScottHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupNavi];
    
    [self setAddAllChildController];
    [self.view addSubview:self.scrollView];
}

- (void)setAddAllChildController {
    [self addChildViewController:[ScottHotViewController new]];
    [self addChildViewController:[ScottNewViewController new]];
    [self addChildViewController:[ScottCareViewController new]];
}

- (void)setupNavi {
    
    [self.naviBarView addSubview:self.segmentCtrl];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"search_15x14"] forState:UIControlStateNormal];
    self.leftView = leftBtn;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"head_crown_24x24"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(headCrownClick) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = btn;
}

- (void)headCrownClick {
    ScottCrownViewController *crownVC = [[ScottCrownViewController alloc] init];
    crownVC.urlStr = @"http://live.9158.com/Rank/WeekRank?Random=10";
    crownVC.titleLabel.text = @"排行榜";
    [self.navigationController pushViewController:crownVC animated:YES];
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentCtrl {
    //控制器view的滚动
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = segmentCtrl.selectedSegmentIndex * self.scrollView.scott_width;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - UIScrollViewDelegate
//结束滚动时动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //计算当前控制器View索引
    NSInteger index = scrollView.contentOffset.x / scrollView.scott_width;
    //取出子控制器
    UIViewController *viewVc = self.childViewControllers[index];
    viewVc.view.x = scrollView.contentOffset.x;
    viewVc.view.scott_width = [UIScreen scott_screenWidth];
    viewVc.view.scott_height = [UIScreen scott_screenHeight]-49-64;
    [scrollView addSubview:viewVc.view];
}

// 滚动减速时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger index = scrollView.contentOffset.x / scrollView.scott_width;
    
    self.segmentCtrl.selectedSegmentIndex = index;
}


#pragma mark - lazy
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), [UIScreen scott_screenHeight] - CGRectGetHeight(self.naviBarView.frame) - CGRectGetHeight(self.tabBarController.tabBar.frame));
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;//分页
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * self.childViewControllers.count , 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        // 添加第一个控制器的view
        [self scrollViewDidEndScrollingAnimation:_scrollView];
        
    }
    return _scrollView;

}
- (HMSegmentedControl *)segmentCtrl {
    if (!_segmentCtrl) {
        _segmentCtrl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"最热",@"最新",@"关注"]];
        _segmentCtrl.frame = CGRectMake(45, 20, [UIScreen scott_screenWidth] - 90, 44);
        _segmentCtrl.shouldAnimateUserSelection = YES;
        _segmentCtrl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        _segmentCtrl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        _segmentCtrl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentCtrl.selectionIndicatorColor = [UIColor whiteColor];
        _segmentCtrl.backgroundColor = [UIColor clearColor];
        _segmentCtrl.selectionIndicatorHeight = 2.0;
        [_segmentCtrl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentCtrl;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
