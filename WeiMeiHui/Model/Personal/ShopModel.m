//
//  ShopModel.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

+(instancetype)shopModeltWithDict:(NSDictionary *)dic{
    
    ShopModel *order = [[ShopModel alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    return order;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
