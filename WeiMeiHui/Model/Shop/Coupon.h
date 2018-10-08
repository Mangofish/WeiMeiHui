//
//  Coupon.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"

@interface Coupon : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *coupon_dis;
@property (nonatomic, copy) NSString *par_value;
@property (nonatomic, copy) NSString *coupon_mode_id;
@property (nonatomic, copy) NSString *coupon_mode_name;
@property (nonatomic, copy) NSString *coupon_content;
@property (nonatomic, copy) NSString *threshold;


+(instancetype)couponWithDict:(NSDictionary *)dic;
@property (nonatomic, strong) TYTextContainer *textContainer;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) CGFloat contentHeightMain;
@property (nonatomic, strong) TYTextContainer *textContainerMain;

@end
