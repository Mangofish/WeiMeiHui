//
//  MyYetOrder.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyYetOrders : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *service_type;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *receiving_num;
@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *ID;

+(instancetype)myYetOrdersWithDict:(NSDictionary *)dic;

@end
