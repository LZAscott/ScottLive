//
//  ScottLivingCollectionController.m
//  QQLive
//
//  Created by bopeng on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottLivingCollectionController.h"

@interface ScottLivingCollectionController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ScottLivingCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
    /*
     
     // 设置直播占位图片
     NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",_model.creator.portrait]];
     [self.imageView sd_setImageWithURL:imageUrl placeholderImage:nil];
     
     // 拉流地址
     NSURL *url = [NSURL URLWithString:_model.stream_addr];
     
     // 创建IJKFFMoviePlayerController：专门用来直播，传入拉流地址就好了
     IJKFFMoviePlayerController *playerVc = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:nil];
     
     // 准备播放
     [playerVc prepareToPlay];
     
     // 强引用，反正被销毁
     _player = playerVc;
     
     playerVc.view.frame = [UIScreen mainScreen].bounds;
     
     [self.view insertSubview:playerVc.view atIndex:1];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
