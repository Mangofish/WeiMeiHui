//
//  CommentList.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTextContainer.h"
@interface CommentList : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) double nameWidth;
@property (nonatomic, assign) double createTimeWidth;
@property (nonatomic, strong) TYTextContainer *textContainer;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) double contentHeight;
@property (nonatomic, copy) NSString *from_uuid;
@property (nonatomic, copy) NSString *grade_name;

+(instancetype)commentListWithDict:(NSDictionary *)dic;

@end
