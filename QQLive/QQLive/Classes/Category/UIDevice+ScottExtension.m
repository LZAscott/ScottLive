//
//  UIDevice+ScottExtension.m
//  QQLive
//
//  Created by Scott_Mr on 2016/11/24.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import "UIDevice+ScottExtension.h"

@implementation UIDevice (ScottExtension)

- (BOOL)scott_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@end
