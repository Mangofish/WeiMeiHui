//
//  ChooseShops.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseShops : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *shop_name;


+(instancetype)shopListWithDict:(NSDictionary *)dic;

@end
