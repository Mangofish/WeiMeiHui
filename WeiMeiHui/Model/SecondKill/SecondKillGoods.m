//
//  SecondKillGoods.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SecondKillGoods.h"

@implementation SecondKillGoods

+(instancetype)goodsWithDict:(NSDictionary *)dic{
    
    SecondKillGoods *order = [[SecondKillGoods alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    order.ID = [dic objectForKey:@"id"];
    return order;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
