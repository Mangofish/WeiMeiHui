//
//  GroupWaitingForPayViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupWaitingForPayViewController : UMClickViewController

@property (nonatomic,copy)NSString *ID;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic,copy)NSString *status;

@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *titleStr;
@end
