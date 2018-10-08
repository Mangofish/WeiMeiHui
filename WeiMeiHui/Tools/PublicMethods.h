//
//  PublicMethods.h
//  WMHUser
//
//  Created by Mac on 16/10/19.
//  Copyright © 2016年 罗大勇. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PublicMethods : NSObject

+(NSString *) md5:(NSString *) input;
+(NSString*)dataTojsonString:(id)object;
+(NSString*)dataTojsonString2:(id)object;
//+ (void)shareType:(NSInteger)sender andTitle:(NSString *)title;
+(BOOL)isLogIn;
+(BOOL)isHaveAddress;
+(BOOL)isHaveMessage;

/**支付宝支付*/
+(void)aliPayActionWithOrderNum:(NSString *)orderNum andPrice:(double)price andNotify:(NSString *)url;

/**微信支付*/
+(void)wxPayActionWithOrderNum:(NSString *)orderNum andPrice:(NSString *)price andNotify:(NSString *)url;

+(BOOL)isInternetAlright:(NSDictionary *)dic;

/**满减优惠券计算*/

+ (double) couponCaculatePrice:(NSDictionary *)couponDic beforePrice:(double)beforePrice;


/**
 获取设备信息
 */
+(NSArray *)requestDeviceInfo;

/**判断固话*/
+ (BOOL)isLocatedNumber:(NSString *)mobileNum;

/**
 * 手机号码格式验证
 */
+(BOOL)isTelphoneNumber:(NSString *)telNum;



@end
