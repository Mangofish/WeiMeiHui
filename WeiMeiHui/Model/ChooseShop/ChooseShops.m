//
//  ChooseShops.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChooseShops.h"

@implementation ChooseShops

+(instancetype)shopListWithDict:(NSDictionary *)dic{
    
    ChooseShops *order = [[ChooseShops alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    return order;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}


@end
