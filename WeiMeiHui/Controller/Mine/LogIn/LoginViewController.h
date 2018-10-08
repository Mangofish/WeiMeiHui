//
//  LoginViewController.h
//  WeiMeiHui
//
//  Created by Mac on 17/5/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UMClickViewController

@property (nonatomic, copy) void(^logComplete)(BOOL isLog);

@end
