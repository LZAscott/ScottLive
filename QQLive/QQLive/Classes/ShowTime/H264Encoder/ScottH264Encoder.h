//
//  ScottH264Encoder.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface ScottH264Encoder : NSObject

// 初始化基本配置
- (void)initWithConfiguration;
- (void)initEncode:(int)width  height:(int)height;
- (void)encode:(CMSampleBufferRef)sampleBuffer;

@end
