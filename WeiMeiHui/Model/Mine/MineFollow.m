//
//  MineFollow.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MineFollow.h"

@implementation MineFollow

+(instancetype)orderCommentWithDict:(NSDictionary *)dic{
    
    MineFollow *order = [[MineFollow alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    return order;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
