//
//  PayStyleViewController.h
//  WeiMeiHui
//
//  Created by Mac on 17/5/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PayStyleViewController : UMClickViewController

@property (nonatomic, copy) NSString * ordernumber;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * notifyUrlAli;
@property (nonatomic, copy) NSString * notifyUrlWeixin;

@property (nonatomic, assign) BOOL isCard;
@end
