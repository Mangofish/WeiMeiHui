//
//  MainOrderStatusWait.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"

@interface MainOrderStatusWait : NSObject

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *people_num;
@property (nonatomic, assign) double contentHeight;

@property (nonatomic, copy) NSString *service_type;
@property (nonatomic, copy) NSString *custom_id;
@property (nonatomic, copy) NSString *order_number;

@property (nonatomic, strong) TYTextContainer *textContainer;

+(instancetype)mainOrderStatusWithDict:(NSDictionary *)dic;

@end
