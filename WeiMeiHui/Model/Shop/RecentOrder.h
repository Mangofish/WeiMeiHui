//
//  RecentOrder.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentOrder : NSObject

@property (nonatomic, copy) NSString *common_order_num;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *residue;


+(instancetype)recentOrderWithDict:(NSDictionary *)dic;

@end
