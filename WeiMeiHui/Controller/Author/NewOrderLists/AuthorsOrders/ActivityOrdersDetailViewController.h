//
//  ActivityOrdersDetailViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityOrdersDetailViewController : UIViewController

@property (nonatomic,copy)NSString *ID;

@property (nonatomic,assign)NSUInteger status;

@property (nonatomic,assign)NSUInteger type;

@property (nonatomic,copy)NSString *titleStr;

@property (nonatomic,copy)NSString *path;
@end
