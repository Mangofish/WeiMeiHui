//
//  ChangeSignViewController.h
//  WeiMeiHui
//
//  Created by Mac on 2017/6/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeSignViewController : UMClickViewController

@property (nonatomic, copy) void(^changeComplete)(NSString * aSign);

@end
