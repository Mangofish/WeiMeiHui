//
//  ShopAndAuthor.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopAndAuthor : NSObject

@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *distance;

@property (nonatomic, copy) NSString *average_score;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, copy) NSString *dump_name;
@property (nonatomic, copy) NSString *score_order;
@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSArray *author_data;
@property (nonatomic, copy) NSArray *son_pic;
@property (nonatomic, copy) NSArray *activity_data;

+(instancetype)shopAuthorWithDict:(NSDictionary *)dic;

@end
