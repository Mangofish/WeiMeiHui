//
//  TiePhoneViewController.h
//  WeiMeiHui
//
//  Created by Mac on 2017/6/22.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiePhoneViewController : UMClickViewController

@property (nonatomic, copy) NSString *fromType;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *titleInfoStr;

@property (nonatomic, assign) NSUInteger type;

@end
