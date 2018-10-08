//
//  AreaModel.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *shop_count;

+(instancetype)areaModeltWithDict:(NSDictionary *)dic;

@end
