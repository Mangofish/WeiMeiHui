//
//  CouponDown.h
//  WeiMeiHui
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TYTextContainer.h"


@interface CouponDown : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *coupon_dis;
@property (nonatomic, copy) NSString *par_value;
@property (nonatomic, copy) NSString *coupon_mode_id;
@property (nonatomic, copy) NSString *coupon_mode_name;
@property (nonatomic, copy) NSString *coupon_content;
@property (nonatomic, copy) NSString *threshold;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isDown;

+(instancetype)couponWithDict:(NSDictionary *)dic;

@property (nonatomic, strong) TYTextContainer *moneyTextContainer;
@property (nonatomic, assign) CGFloat moneyHeight;

@property (nonatomic, strong) TYTextContainer *detailTextContainer;
@property (nonatomic, assign) CGFloat detailHeight;

@property (nonatomic, strong) TYTextContainer *titleTextContainer;
@property (nonatomic, assign) CGFloat titleHeight;

@property (nonatomic, strong) TYTextContainer *timeTextContainer;
@property (nonatomic, assign) CGFloat timeHeight;

@property (nonatomic, strong) TYTextContainer *textContainer;
@property (nonatomic, assign) CGFloat contentHeight;


@end
