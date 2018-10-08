//
//  ShopCard.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopCard.h"

@implementation ShopCard

+(instancetype)shopCardWithDict:(NSDictionary *)dic{
    
    ShopCard *order = [[ShopCard alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    
    return order;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
