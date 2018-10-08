//
//  WeiUserInfo.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiUserInfo.h"

@implementation WeiUserInfo

+(instancetype)weiUserInfoWithDict:(NSDictionary *)dic{
    
    WeiUserInfo *order = [[WeiUserInfo alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    return order;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
