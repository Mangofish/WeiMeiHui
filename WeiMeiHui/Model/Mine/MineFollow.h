//
//  MineFollow.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineFollow : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *is_mutual;

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *follow_count;
@property (nonatomic, copy) NSString *fans_count;
@property (nonatomic, copy) NSString *send_count;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *grade;

+(instancetype)orderCommentWithDict:(NSDictionary *)dic;

@end
