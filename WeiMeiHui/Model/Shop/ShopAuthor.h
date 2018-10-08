//
//  ShopAuthor.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopAuthor : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *author_uuid;
@property (nonatomic, copy) NSString *fans_num;
@property (nonatomic, copy) NSString *average_score;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *is_relationship;
@property (nonatomic, copy) NSString *graded;
@property (nonatomic, copy) NSString *region_name;
@property (nonatomic, copy) NSString *is_recent;
@property (nonatomic, copy) NSString *recent_name;
@property (nonatomic, copy) NSArray *author_goods;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *grade_name;
@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *pay_price;
@property (nonatomic, copy) NSString *is_author;
@property (nonatomic, copy) NSArray *service;
@property (nonatomic, copy) NSString *author_name;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *score_show;
@property (nonatomic, copy) NSString *is_attention;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, assign) double distanceWidth;
@property (nonatomic, copy) NSString *dump_name;

+(instancetype)shopAuthorWithDict:(NSDictionary *)dic;
@end
