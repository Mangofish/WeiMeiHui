//
//  AlreadyPayViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlreadyPayViewController : UMClickViewController
@property (nonatomic,copy)NSString *orderID;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,copy)NSString *statustr;
@property (nonatomic,copy)NSString *afterStatus;

@property (nonatomic,assign)NSUInteger btnStatus;
@property (nonatomic,copy)NSString *infoStr;

@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
