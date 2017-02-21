//
//  ScottNetworkTool.m
//  ScottNetworkTool
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "ScottNetworkTool.h"

NSString *const ScottBaseURL = @"http://live.9158.com";

@protocol ScottNetworkToolsProxy <NSObject>

@optional
/// AFN 内部的数据访问方法
///
/// @param method           HTTP 方法
/// @param URLString        URLString
/// @param parameters       请求参数字典
/// @param uploadProgress   上传进度
/// @param downloadProgress 下载进度
/// @param success          成功回调
/// @param failure          失败回调
///
/// @return NSURLSessionDataTask，需要 resume
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end


@interface ScottNetworkTool ()<ScottNetworkToolsProxy>


@end



@implementation ScottNetworkTool

+ (instancetype)shareTools {
    static ScottNetworkTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:ScottBaseURL]];
    });
    return instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        }];
        [self.reachabilityManager startMonitoring];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
        [(AFJSONResponseSerializer *)self.responseSerializer setRemovesKeysWithNullValues:YES];
    }
    return self;
}

/**
 封装AFNetworking网络请求

 @param method 请求方式
 @param urlString 请求链接
 @param parameters 请求参数
 @param finished 完成回调
 */
- (void)requestWithMethod:(ScottRequestMethod)method andURLString:(NSString *)urlString parameters:(NSDictionary *)parameters finishCallBack:(ScottRequestCallBack)finished {
    
    NSString *methodName = (method == GET) ? @"GET" : @"POST";
    
   NSURLSessionDataTask *task = [self dataTaskWithHTTPMethod:methodName URLString:urlString parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        finished(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"网络请求错误 %@", error.localizedDescription);
        finished(nil, error);
    }];

    [task resume];
}


/**
 上传文件的封装

 @param data 要上传的二进制数据
 @param URLString 请求链接
 @param name 接收上传数据的服务器字段
 @param parameters 请求参数
 @param finished 请求回调
 */
- (void)uploadData:(NSData *)data URLString:(NSString *)URLString name:(NSString *)name parameters:(NSDictionary *)parameters finishCallBack:(ScottRequestCallBack)finished {
    [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:@"xxx" mimeType:@"application/octet-stream"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求错误 %@",error.localizedDescription);
        finished(nil, error);
    }];
}

- (void)tokenRequestWithMethod:(ScottRequestMethod)method andURLString:(NSString *)URLString parameters:(NSDictionary *)parameters name:(NSString *)name data:(NSData *)data finishCallBack:(ScottRequestCallBack)finished {
    
    // 此处获取token
//    NSString *token = [UserModel shareInstance].token;
//    if (token == nil) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ScottShouldLoginNotifacation object:nil userInfo:nil];
//        finished(nil, nil);
//        return;
//    }
//    
//    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
//    mDic[@"token"] = token;
    
//    if (name && data) {
//        [self uploadData:data URLString:URLString name:name parameters:mDic finishCallBack:finished];
//    }else{
//        [self requestWithMethod:method andURLString:URLString parameters:mDic finishCallBack:finished];
//    }
}


@end
