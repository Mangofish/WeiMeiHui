//
//  ShopModel.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_pic;
@property (nonatomic, copy) NSString *shop_address;

@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *openTime;
@property (nonatomic, copy) NSString *good_percent;
@property (nonatomic, copy) NSString *better_percent;

@property (nonatomic, copy) NSString *shop_distance;
@property (nonatomic, copy) NSString *project_one;
@property (nonatomic, copy) NSString *project_two;
@property (nonatomic, copy) NSString *product_num;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *is_relationship;
@property (nonatomic, copy) NSString *evaluate_count;
@property (nonatomic, copy) NSString *sum_average_score;
@property (nonatomic, copy) NSString *sum_score;

+(instancetype)shopModeltWithDict:(NSDictionary *)dic;


@end
