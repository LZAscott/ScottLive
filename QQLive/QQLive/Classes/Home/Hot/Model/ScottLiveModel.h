//
//  ScottLiveModel.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/25.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScottLiveModel : NSObject

/** 群众数目 */
@property (nonatomic, assign) NSUInteger allnum;
/** 直播图 */
@property (nonatomic, copy  ) NSString   *bigpic;
/** 直播流地址 */
@property (nonatomic, copy  ) NSString   *flv;
/** 所在城市 */
@property (nonatomic, copy  ) NSString   *gps;
/** 用户ID */
@property (nonatomic, copy  ) NSString   *userId;
/** 星级 */
@property (nonatomic, assign) NSUInteger starlevel;
/** 主播头像 */
@property (nonatomic, copy  ) NSString   *smallpic;
/** 主播名 */
@property (nonatomic, copy  ) NSString   *myname;
/** 个性签名 */
@property (nonatomic, copy  ) NSString   *signatures;
/** 直播房间号码 */
@property (nonatomic, assign) NSUInteger roomid;
/** 所处服务器 */
@property (nonatomic, assign) NSUInteger serverid;
/** 排名 */
@property (nonatomic, assign) NSUInteger pos;
/** 用户ID */
@property (nonatomic, assign) NSString   *useridx;

@end
