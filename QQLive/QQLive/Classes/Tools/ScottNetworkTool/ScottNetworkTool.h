//
//  ScottNetworkTool.h
//  ScottNetworkTool
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum : NSUInteger {
    GET,
    POST,
} ScottRequestMethod;

/// 网络请求回调类型
///
/// @param result 返回结果
/// @param error  错误信息
typedef void (^ScottRequestCallBack)(id result, NSError *error);


@interface ScottNetworkTool : AFHTTPSessionManager

+ (instancetype)shareTools;


- (void)requestWithMethod:(ScottRequestMethod)method andURLString:(NSString *)urlString parameters:(NSDictionary *)parameters finishCallBack:(ScottRequestCallBack)finished;

- (void)uploadData:(NSData *)data URLString:(NSString *)URLString name:(NSString *)name parameters:(NSDictionary *)parameters finishCallBack:(ScottRequestCallBack)finished;

- (void)tokenRequestWithMethod:(ScottRequestMethod)method andURLString:(NSString *)URLString parameters:(NSDictionary *)parameters name:(NSString *)name data:(NSData *)data finishCallBack:(ScottRequestCallBack)finished;

@end
