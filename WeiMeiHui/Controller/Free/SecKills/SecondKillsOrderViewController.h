//
//  SecondKillsOrderViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondKillsOrderViewController : UIViewController

@property (nonatomic,copy)NSString *ID;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *sec_price;
@property (nonatomic,copy)NSString *org_price;

@property (nonatomic,copy)NSString *activity_id;

@property (nonatomic,copy)NSString *session_id;

@property (nonatomic,assign)double price;

@property (nonatomic,assign)double secPrice;

@property (nonatomic,copy)NSString *phone;
@end
