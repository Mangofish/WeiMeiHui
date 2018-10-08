//
//  RulesItem.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"

@interface RulesItem : NSObject

@property (nonatomic, copy) NSString *detail_name;
@property (nonatomic, copy) NSString *detail_pic;
@property (nonatomic, copy) NSString *detail_unit;
@property (nonatomic, copy) NSString *tag_id;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) TYTextContainer *textContainer;

+(instancetype)authorGoodsWithDict:(NSDictionary *)dic;

@end
