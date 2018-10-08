//
//  AreaModel.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

+(instancetype)areaModeltWithDict:(NSDictionary *)dic{
    
    AreaModel *order = [[AreaModel alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    order.ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
    
    return order;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
