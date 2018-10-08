//
//  WeiContent.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"
@interface WeiContent : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *issue_id;
@property (nonatomic, copy) NSArray *pic;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *shop_address;
@property (nonatomic, copy) NSString *shop_lng;
@property (nonatomic, copy) NSString *shop_lat;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *praises;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *is_praises;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *grade_name;
@property (nonatomic, copy) NSString *is_advertise;
@property (nonatomic, copy) NSString *level;

@property (nonatomic, assign) CGFloat nameWidth;
@property (nonatomic, assign) CGFloat nickWidth;
@property (nonatomic, assign) CGFloat distanceWidth;
@property (nonatomic, assign) CGFloat createTimeWidth;
@property (nonatomic, assign) CGFloat viewsWidth;
@property (nonatomic, assign) CGFloat addressWidth;
@property (nonatomic, assign) CGFloat praiseWidth;
@property (nonatomic, assign) CGFloat commentWidth;

@property (nonatomic, strong) TYTextContainer *textContainer;

@property (nonatomic, assign) CGFloat contentHeight;
@property(assign,nonatomic) float  contengImageHeight;//图片高度

+(instancetype)contentListWithDict:(NSDictionary *)dic;

@end
