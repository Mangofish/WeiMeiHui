//
//  ThreeOrder.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeOrder : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *grade_name;
@property (nonatomic, copy) NSString *is_pay;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *org_price;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *residue_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *use_time;
@property (nonatomic, copy) NSString *author_uuid;
@property (nonatomic, copy) NSString *qrCode;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *order_status;


@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *shop_pic;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, copy) NSString *average_score;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *score_order;
@property (nonatomic, copy) NSString *dump_name;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *sec_price;
@property (nonatomic, copy) NSString *refund_help;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *expire_time;
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *activity_content;
@property (nonatomic, copy) NSString *is_secKill;

+(instancetype)recentOrderWithDict:(NSDictionary *)dic;


@end
