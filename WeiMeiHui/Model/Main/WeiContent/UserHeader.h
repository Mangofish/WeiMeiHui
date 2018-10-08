//
//  UserHeader.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHeader : NSObject
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, copy) NSArray *attention_count;
@property (nonatomic, copy) NSArray *user_pics;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *obtain;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *praise_count;
@property (nonatomic, copy) NSString *is_relationship;

+(instancetype)headWithDict:(NSDictionary *)dic;
@end
