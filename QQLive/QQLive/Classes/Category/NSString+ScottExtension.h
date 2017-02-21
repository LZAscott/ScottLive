//
//  NSString+ScottExtension.h
//  QQLive
//
//  Created by Scott_Mr on 2016/11/23.
//  Copyright © 2016年 Scott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ScottExtension)


/**
 验证邮箱

 @param email 邮箱字符串
 @return 是否是邮箱
 */
+ (BOOL)scott_validateEmail:(NSString *)email;


/**
 手机号码验证

 @param mobile 手机号码字符串
 @return 是否手机号
 */
+ (BOOL)scott_validateMobile:(NSString *)mobile;

/**
 车牌号验证

 @param carNo 车牌号码字符串
 @return 是否车牌号
 */
+ (BOOL)scott_validateCarNo:(NSString *)carNo;

/**
 车型验证

 @param CarType 车型字符串
 @return 是否车型
 */
+ (BOOL)scott_validateCarType:(NSString *)CarType;

/**
 用户名验证

 @param name 用户名字符串
 @return 是否用户名
 */
+ (BOOL)scott_validateUserName:(NSString *)name;

/**
 验证昵称

 @param nickname 昵称字符串
 @return 是否昵称
 */
+ (BOOL)scott_validateNickname:(NSString *)nickname;

/**
 密码认证

 @param passWord 密码字符串
 @return 是否密码
 */
+ (BOOL)scott_validatePassword:(NSString *)passWord;

/**
 验证身份证号

 @param identityCard 身份证号字符串
 @return 是否是身份证号
 */
+ (BOOL)scott_validateIdentityCard: (NSString *)identityCard;


/**
 对当前字符串进行 BASE 64 编码

 @param str 需要编码的字符串
 @return 编码后的字符串
 */
+ (NSString *)scott_base64EncodeWithStr:(NSString *)str;


/**
 对当前字符串进行 BASE 64 解码

 @param str 需要解码的字符串
 @return 解码后的字符串
 */
+ (NSString *)scott_base64DecodeWithStr:(NSString *)str;

@end
