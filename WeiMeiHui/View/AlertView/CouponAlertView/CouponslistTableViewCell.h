//
//  CouponslistTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAttributedLabel.h"

#import "CouponDown.h"

@protocol CouponslistTableViewCellDelegate <NSObject>

- (void)useCouponAction:(UIButton *)sender;
- (void)infoAction:(UIButton *)sender;


@end


@interface CouponslistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property(nonatomic, strong) TYAttributedLabel *moneyLab;
@property(nonatomic, strong) TYAttributedLabel *moneyDetailLab;
@property(nonatomic, strong) TYAttributedLabel *titleLab;
@property(nonatomic, strong) TYAttributedLabel *timeLab;
@property(nonatomic, strong) TYAttributedLabel *contentLab;

//@property(nonatomic, strong) UIButton *detailBtn;
//@property(nonatomic, strong) UIButton *useBtn;

@property (weak, nonatomic) IBOutlet UIButton *useBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic)  CouponDown *coupon;
@property (strong, nonatomic)  CouponDown *outcoupon;
@property (strong, nonatomic)  CouponDown *losecoupon;

@property (assign, nonatomic)  CGFloat cellHeight;

@property (nonatomic, weak) id <CouponslistTableViewCellDelegate>delegate;
@end
