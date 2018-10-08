//
//  MineComment.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MineComment.h"

@implementation MineComment

+(instancetype)orderCommentWithDict:(NSDictionary *)dic{
    
    MineComment *order = [[MineComment alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    return order;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
