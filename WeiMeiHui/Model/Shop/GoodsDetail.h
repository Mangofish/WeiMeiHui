//
//  GoodsDetail.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetail : NSObject

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *org_price;
@property (nonatomic, copy) NSString *sec_org_price;
@property (nonatomic, copy) NSString *tag_id;
@property (nonatomic, copy) NSString *tag_name;
@property (nonatomic, copy) NSString *sales;
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *activity_dis;
@property (nonatomic, copy) NSString *is_group;
@property (nonatomic, copy) NSString *activity_id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *average_score;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *author_uuid;
@property (nonatomic, copy) NSString *fans_num;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *region_name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *non_use;
@property (nonatomic, copy) NSString *reservation_information;
@property (nonatomic, copy) NSString *useful_people;
@property (nonatomic, copy) NSString *expiry_date;
@property (nonatomic, copy) NSString *reminder;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *customer_service;
@property (nonatomic, copy) NSArray *goods_service_list;
@property (nonatomic, copy) NSString *coupon_dis;
@property (nonatomic, copy) NSString *in_group;
@property (nonatomic, copy) NSArray *recent_in;
@property (nonatomic, copy) NSArray *coupon_list;
@property (nonatomic, copy) NSDictionary *recent_order;
@property (nonatomic, copy) NSArray *other_goods_list;
@property (nonatomic, copy) NSArray *goods_detail_list;
@property (nonatomic, copy) NSArray *need_know;
@property (nonatomic, copy) NSString *group_price;
@property (nonatomic, copy) NSString *dis_price;
@property (nonatomic, copy) NSString *group_num;
@property (nonatomic, copy) NSArray *in_user;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *overplus;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *suc_time;
@property (nonatomic, copy) NSString *qrCode;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pay_price;
@property (nonatomic, copy) NSString *is_activity;
@property (nonatomic, copy) NSString *activity_price;
@property (nonatomic, copy) NSString *group_name;
@property (nonatomic, copy) NSString *share_url;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *sharePic;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *group_rule_url;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSArray *evaluate_list;
@property (nonatomic, copy) NSArray *son_pic;
@property (nonatomic, copy) NSString *evaluate_count;
@property (nonatomic, copy) NSString *shop_uuid;
@property (nonatomic, copy) NSString *activity_content;
@property (nonatomic, copy) NSString *sec_price;
@property (nonatomic, copy) NSString *use_time;

+(instancetype)authorGoodsWithDict:(NSDictionary *)dic;

@end
