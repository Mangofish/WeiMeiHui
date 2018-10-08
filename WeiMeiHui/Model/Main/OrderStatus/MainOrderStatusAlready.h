//
//  MainOrderStatus.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYAttributedLabel.h"
@interface MainOrderStatusAlready : NSObject

@property (nonatomic, copy) NSString *author_image;
@property (nonatomic, copy) NSString *author_uuid;
@property (nonatomic, copy) NSString *author_name;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *graded;
@property (nonatomic, assign) double nameWidth;
@property (nonatomic, assign) double countWidth;

@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, assign) double contentHeight;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *qrCode;
@property (nonatomic, copy) NSString *service_type;
@property (nonatomic, copy) NSString *shop_name;
@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSArray *service;
@property (nonatomic, copy) NSString *service_tel;
@property (nonatomic, copy) NSArray *order_pic;
@property (nonatomic, copy) NSString *author_content;

@property (nonatomic, strong)  TYTextContainer * textContainer;

+(instancetype)mainOrderStatusWithDict:(NSDictionary *)dic;
@end
