//
//  OrderComment.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"

@interface OrderComment : NSObject

@property (nonatomic, copy) NSString *eva_nickname;
@property (nonatomic, copy) NSString *eva_image;
@property (nonatomic, copy) NSString *eva_starts;
@property (nonatomic, copy) NSString *eva_content;
@property (nonatomic, copy) NSString *eva_time;
@property (nonatomic, copy) NSArray *eva_tag;
@property (nonatomic, copy) NSArray *eva_pic;

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *activity_name;
@property (nonatomic, copy) NSString *activityPrice;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *org_price;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *par_value;
@property (nonatomic, copy) NSString *shop_subsidy;
@property (nonatomic, copy) NSString *is_eva;


@property (nonatomic, assign) CGFloat contentHeight;

+(instancetype)orderCommentWithDict:(NSDictionary *)dic;

@property (nonatomic, strong) TYTextContainer *textContainer;
@end
