//
//  CYLTabBarControllerConfig.h
//  CYLTabBarController
//
//  v1.16.0 Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 15/11/3.
//  Copyright © 2015年 https://github.com/ChenYilong .All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"
#import <RongIMKit/RongIMKit.h>

@interface CYLTabBarControllerConfig : NSObject <RCIMReceiveMessageDelegate>

@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;
@property (nonatomic, copy) NSString *context;

@end
