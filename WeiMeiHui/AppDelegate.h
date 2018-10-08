//
//  AppDelegate.h
//  WeiMeiHui
//
//  Created by Mac on 17/4/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

typedef enum JumpType{
    ROUTE_MANAGER= 0,
}MYJumpType;

static NSString *appKey = @"f7f31bfff0ff92fc5d817769";
static NSString *channel = @"Publish channel";


@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMUserInfoDataSource,RCIMReceiveMessageDelegate>


@property (assign, nonatomic) MYJumpType jumpType;
@property (strong, nonatomic) UIWindow *window;


@end

