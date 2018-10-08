//
//  CouponTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAttributedLabel.h"
#import "Coupon.h"

@interface CouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *mode;

@property (strong, nonatomic)  TYAttributedLabel *details;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UILabel *erLab;


@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (strong, nonatomic)  Coupon *coupon;
@property (strong, nonatomic)  Coupon *couponOut;
@property (strong, nonatomic)  Coupon *couponList;

@property (weak, nonatomic) IBOutlet UIButton *outBtn;

@property (assign, nonatomic)  CGFloat cellHeight;
+ (instancetype)couponTableViewCell;

@end
