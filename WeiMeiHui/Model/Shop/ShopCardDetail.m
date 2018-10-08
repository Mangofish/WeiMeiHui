//
//  ShopCardDetail.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopCardDetail.h"

@implementation ShopCardDetail

+(instancetype)shopCardDetailWithDict:(NSDictionary *)dic{
    
    ShopCardDetail *order = [[ShopCardDetail alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    
    return order;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}


@end
