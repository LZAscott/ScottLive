//
//  NSDictionary+ScottExtension.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "NSDictionary+ScottExtension.h"

@implementation NSDictionary (ScottExtension)

- (NSString *)scott_dictionaryToJson {
    NSString *json = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:&error];
    
    if (!error) {
        json = [[NSString alloc] initWithData:jsonData
                                     encoding:NSUTF8StringEncoding];
        return json;
    } else {
        return error.localizedDescription;
    }
}

@end
