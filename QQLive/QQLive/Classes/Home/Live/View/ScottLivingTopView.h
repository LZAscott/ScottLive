//
//  ScottLivingTopView.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/28.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScottLiveModel;
@interface ScottLivingTopView : UIView

+ (instancetype)livingTopView;

@property (nonatomic, strong) ScottLiveModel *liveModel;


@end
