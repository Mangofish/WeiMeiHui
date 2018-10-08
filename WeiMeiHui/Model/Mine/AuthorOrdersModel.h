//
//  AuthorOrdersModel.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"

@interface AuthorOrdersModel : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *custom_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *min_price;
@property (nonatomic, copy) NSString *max_price;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *service_name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *section;
@property (nonatomic, copy) NSString *rest_time;
@property (nonatomic, copy) NSString *order_number;
@property (nonatomic, copy) NSString *dumps_name;
@property (nonatomic, copy) NSArray *pics;
@property (nonatomic, copy) NSArray *pics_author;
@property (nonatomic, copy) NSString *service_area;
@property (nonatomic, copy) NSString *author_content;
@property (nonatomic, copy) NSString *service_type;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *title;




@property (nonatomic, assign) double contentHeight;
@property (nonatomic, assign) double authorContentHeight;

@property (nonatomic, strong) TYTextContainer *textContainer;
@property (nonatomic, strong) TYTextContainer *authorTextContainer;

+(instancetype)orderInfoWithDict:(NSDictionary *)dic;

@end
