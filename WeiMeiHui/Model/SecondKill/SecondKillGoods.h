//
//  SecondKillGoods.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecondKillGoods : NSObject

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *org_price;
@property (nonatomic, copy) NSString *sec_price;
@property (nonatomic, copy) NSString *inventory;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *remind_count;
@property (nonatomic, copy) NSString *percent;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *session_id;
@property (nonatomic, copy) NSString *ID;

+(instancetype)goodsWithDict:(NSDictionary *)dic;
@end
