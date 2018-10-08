//
//  WeiUserInfo.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiUserInfo : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *personal_sign;
@property (nonatomic, copy) NSString *send_count;
@property (nonatomic, copy) NSString *collect_count;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *follow_count;

@property (nonatomic, copy) NSString *city_id;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *is_address;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *cut_price;
@property (nonatomic, copy) NSString *dyeing_price;
@property (nonatomic, copy) NSString *obtain;
@property (nonatomic, copy) NSString *completeness;
@property (nonatomic, copy) NSString *custom_num;
@property (nonatomic, copy) NSString *group_num;
@property (nonatomic, copy) NSString *coupon_count;

+(instancetype)weiUserInfoWithDict:(NSDictionary *)dic;

@end
