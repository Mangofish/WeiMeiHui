//
//  AuthorGoods.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorGoods : NSObject

@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *org_price;
@property (nonatomic, copy) NSString *dis_price;
@property (nonatomic, copy) NSString *tag_name;
@property (nonatomic, copy) NSString *sales;

@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *is_group;
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *sold;
@property (nonatomic, copy) NSString *sold_order;
@property (nonatomic, copy) NSString *grade_name;
@property (nonatomic, copy) NSString *sale_count;
@property (nonatomic, copy) NSString *pay_time;

@property (nonatomic, copy) NSString *package_name;
@property (nonatomic, copy) NSString *package_detail;

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *shop_name;

+(instancetype)authorGoodsWithDict:(NSDictionary *)dic;
@end
