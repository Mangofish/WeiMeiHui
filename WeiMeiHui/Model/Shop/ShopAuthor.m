//
//  ShopAuthor.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopAuthor.h"

@implementation ShopAuthor

+(instancetype)shopAuthorWithDict:(NSDictionary *)dic{
    
    ShopAuthor *order = [[ShopAuthor alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    order.distanceWidth = [order.distance textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:14].lineHeight)].width;
    
    
    return order;
    
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
