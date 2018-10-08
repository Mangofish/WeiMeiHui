//
//  ShopAndAuthor.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopAndAuthor.h"

@implementation ShopAndAuthor

+(instancetype)shopAuthorWithDict:(NSDictionary *)dic{
    
    ShopAndAuthor *order = [[ShopAndAuthor alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
   
    return order;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}
@end
