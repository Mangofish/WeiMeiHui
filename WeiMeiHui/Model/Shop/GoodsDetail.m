//
//  GoodsDetail.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GoodsDetail.h"

@implementation GoodsDetail

+(instancetype)authorGoodsWithDict:(NSDictionary *)dic{
    
    GoodsDetail *order = [[GoodsDetail alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    return order;
    
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}


@end
