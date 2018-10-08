//
//  AuthorGoods.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorGoods.h"

@implementation AuthorGoods

+(instancetype)authorGoodsWithDict:(NSDictionary *)dic{
    
    AuthorGoods *order = [[AuthorGoods alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
//    order.distanceWidth = [order.distance textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:14].lineHeight)].width;
    
    
    return order;
    
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}


@end
