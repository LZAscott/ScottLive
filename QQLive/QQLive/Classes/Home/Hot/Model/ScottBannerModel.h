//
//  ScottBannerModel.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScottBannerModel : NSObject

/** 广告时间 */
@property (nonatomic, copy) NSString *addTime;
/** 广告小图 */
@property (nonatomic, copy) NSString *adsmallpic;

@property (nonatomic, copy) NSString *contents;
/** 倒计时 */
@property (nonatomic, assign) NSUInteger cutTime;

@property (nonatomic, copy) NSString *hiddenVer;

/** AD图片 */
@property (nonatomic, copy) NSString *imageUrl;
/** 链接 */
@property (nonatomic, copy) NSString *link;
/** 不知道什么鬼 */
@property (nonatomic, copy  ) NSString   *lrCurrent;
/** AD序号 */
@property (nonatomic, assign) NSUInteger orderid;
/** 房间号 */
@property (nonatomic, assign) NSUInteger roomid;
/** 所在服务器号 */
@property (nonatomic, assign) NSUInteger serverid;
/** 当前状态 */
@property (nonatomic, assign) NSUInteger state;
/** AD名 */
@property (nonatomic, copy  ) NSString   *title;
/** 主播ID */
@property (nonatomic, copy  ) NSString   *useridx;


@end
