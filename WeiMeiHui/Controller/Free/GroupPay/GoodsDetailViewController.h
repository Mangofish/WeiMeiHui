//
//  GoodsDetailViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailViewController : UIViewController

@property (nonatomic,copy)NSString *ID;

@property (nonatomic,assign)NSUInteger isGroup;

@property (nonatomic,copy)NSString *sessionID;

@property (nonatomic,assign)NSUInteger isSecKill;

@property (nonatomic,assign)NSUInteger isSoldKill;

@end
