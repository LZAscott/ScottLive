//
//  ScottLivingBottomView.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LiveBottomToolType) {
    LiveBottomToolTypePublicTalk,   // 弹幕
    LiveBottomToolTypePrivateTalk,  // 私聊
    LiveBottomToolTypeGift,         // 礼物
    LiveBottomToolTypeRank,         // 排行榜
    LiveBottomToolTypeShare,        // 分享
    LiveBottomToolTypeClose         // 关闭
};

typedef void(^livingBottomClickBlock)(LiveBottomToolType type);

@interface ScottLivingBottomView : UIView

@property (nonatomic, copy) livingBottomClickBlock livBottomClickBlock;

@end
