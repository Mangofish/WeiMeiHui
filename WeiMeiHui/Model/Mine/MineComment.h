//
//  MineComment.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineComment : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *pic;



+(instancetype)orderCommentWithDict:(NSDictionary *)dic;

@end
