//
//  NSArray+ScottExtension.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "NSArray+ScottExtension.h"

@implementation NSArray (ScottExtension)

- (NSString *)scott_arrayToJson {
    // 生成一个Foundation对象JSON数据
    NSString *json = nil;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0
                                                     error:&error];
    if(!error) {
        json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return json;
    } else {
        // 返回主用户显示消息的错误
        return error.localizedDescription;
    }
}

@end
