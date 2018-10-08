//
//  UserHeader.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UserHeader.h"

@implementation UserHeader

+(instancetype)headWithDict:(NSDictionary *)dic{
    
    UserHeader *order = [[UserHeader alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    return order;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}

@end
