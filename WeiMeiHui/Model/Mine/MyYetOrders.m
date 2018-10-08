//
//  MyYetOrder.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyYetOrders.h"

@implementation MyYetOrders

+(instancetype)myYetOrdersWithDict:(NSDictionary *)dic{
    
    MyYetOrders *order = [[MyYetOrders alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    order.receiving_num = [NSString stringWithFormat:@"   共%@手艺人接单",order.receiving_num];
    order.order_number = [NSString stringWithFormat:@"订单编号：%@",order.order_number];
    order.ID = dic[@"id"];
    return order;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
