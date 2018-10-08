//
//  MyOrderList.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"
@interface MyOrderList : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *service_type;
@property (nonatomic, copy) NSString *service_name;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *author_time;
@property (nonatomic, assign) double contentHeight;

@property (nonatomic, strong) TYTextContainer *textContainer;

+(instancetype)myOrderListWithDict:(NSDictionary *)dic;


@end
