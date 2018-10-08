//
//  ThreeOrder.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ThreeOrder.h"

@implementation ThreeOrder

+(instancetype)recentOrderWithDict:(NSDictionary *)dic{
    
    ThreeOrder *order = [[ThreeOrder alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
//
//    if (![order.price containsString:@"¥"]) {
//        order.price = [NSString stringWithFormat:@"¥%@",order.price];
//    }
    
    return order;
    
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}


@end
