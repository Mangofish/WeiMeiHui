//
//  ShopCard.h
//  WeiMeiHui
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCard : NSObject

@property (nonatomic, copy) NSString *card_name;
@property (nonatomic, copy) NSString *gift;
@property (nonatomic, copy) NSString *card_price;
@property (nonatomic, copy) NSString *pic_back;

@property (nonatomic, copy) NSString *pay_count;
@property (nonatomic, copy) NSString *org_price;

@property (nonatomic, copy) NSString *card_pic;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *remainder;
@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *order_number;

+(instancetype)shopCardWithDict:(NSDictionary *)dic;


@end
