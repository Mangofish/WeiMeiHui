//
//  WeiOrderWaitOrMoneyViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/6/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiOrderWaitOrMoneyViewController : UIViewController

@property (nonatomic,copy)NSString *ID;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic,copy)NSString *status;

@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *titleStr;

@end
