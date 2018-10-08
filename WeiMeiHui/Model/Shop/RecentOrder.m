//
//  RecentOrder.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "RecentOrder.h"

@implementation RecentOrder

+(instancetype)recentOrderWithDict:(NSDictionary *)dic{
    
    RecentOrder *order = [[RecentOrder alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    return order;
    
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}


@end
