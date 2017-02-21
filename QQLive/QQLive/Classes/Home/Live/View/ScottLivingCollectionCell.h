//
//  ScottLivingCollectionCell.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScottLiveModel;
@interface ScottLivingCollectionCell : UICollectionViewCell

/// 直播
@property (nonatomic, strong) ScottLiveModel *live;
/// 相关的直播或者主播
@property (nonatomic, strong) ScottLiveModel *relateLive;

@property (nonatomic, strong) UIViewController *parentVC;


@property (nonatomic, copy) void (^clickCatViewBlock)();


@end
