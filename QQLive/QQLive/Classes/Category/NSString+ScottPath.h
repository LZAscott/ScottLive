//
//  NSString+ScottPath.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/22.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ScottPath)

/// 给当前文件追加文档路径
- (NSString *)scott_appendDocumentDir;

/// 给当前文件追加缓存路径
- (NSString *)scott_appendCacheDir;

/// 给当前文件追加临时路径
- (NSString *)scott_appendTempDir;

@end
