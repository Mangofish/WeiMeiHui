//
//  CouponTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

+(instancetype)couponTableViewCell{
    
    return [[NSBundle mainBundle] loadNibNamed:@"CouponTableViewCell" owner:self options:nil][0];
    
}

- (void)setCoupon:(Coupon *)coupon{
    
    _price.text = [NSString stringWithFormat:@"¥%@",coupon.par_value];
//    样式
    if ([coupon.coupon_mode_id integerValue] == 3) {
        _price.text = [NSString stringWithFormat:@"%@",coupon.par_value];
        _erLab.hidden = NO;
    }
    
    _mode.text = coupon.coupon_mode_name;
    _time.text = [NSString stringWithFormat:@"%@",coupon.end_time];
    _details.text = coupon.coupon_content;
    _title.text  = coupon.coupon_dis;
    
    _details = [[TYAttributedLabel alloc]init];
    [self.contentView addSubview:_details];
    _details.backgroundColor = [UIColor whiteColor];
    
    _details.textContainer = coupon.textContainerMain;
    _details.frame = CGRectMake(Space*2,75,kWidth-Space*4-60,coupon.contentHeight);
    
    _textBgView.frame = CGRectMake(Space,75,kWidth-Space*2-60,coupon.contentHeight);
    
    _cellHeight = CGRectGetMaxY(_details.frame);
    
}

- (void)setCouponList:(Coupon *)couponList{
    
    _price.text = [NSString stringWithFormat:@"¥%@",couponList.par_value];
    //    样式
    if ([couponList.coupon_mode_id integerValue] == 3) {
        _price.text = [NSString stringWithFormat:@"%@",couponList.par_value];
        _erLab.hidden = NO;
    }
    
    _mode.text = couponList.coupon_mode_name;
    _time.text = [NSString stringWithFormat:@"%@",couponList.end_time];
//    _details.text = couponList.coupon_content;
    _title.text  = couponList.coupon_dis;
    
    _details = [[TYAttributedLabel alloc]init];
    _details.font = [UIFont systemFontOfSize:12];
    
    [self.textBgView addSubview:_details];
    _details.textContainer = couponList.textContainer;
    _details.backgroundColor = [UIColor whiteColor];
    
//    if (couponList.contentHeight > 80) {
//        _details.frame = CGRectMake(Space,-10,kWidth-Space*4,couponList.contentHeight);
//    }else{
        _details.frame = CGRectMake(Space,0,kWidth-Space*4,couponList.contentHeight);
//    }
    
    
    
     _textBgView.frame = CGRectMake(Space,75,kWidth-Space*2,couponList.contentHeight);
    
    
    _cellHeight = CGRectGetMaxY(_textBgView.frame);
    
}

- (void)setCouponOut:(Coupon *)couponOut{
    
    //    样式
    _price.text = [NSString stringWithFormat:@"¥%@",couponOut.par_value];
    //    样式
    if ([couponOut.coupon_mode_id integerValue] == 3) {
        _price.text = [NSString stringWithFormat:@"%@",couponOut.par_value];
        _erLab.hidden = NO;
        
    }
    
    _mode.text = couponOut.coupon_mode_name;
    _time.text = [NSString stringWithFormat:@"%@",couponOut.end_time];
    
    _details = [[TYAttributedLabel alloc]init];
    [self.contentView addSubview:_details];
    
    _details.textContainer = couponOut.textContainer;
    _details.frame = CGRectMake(Space*2,75,kWidth-Space*4,couponOut.contentHeight);
    
    _title.text  = couponOut.coupon_dis;
    
    _textBgView.frame = CGRectMake(Space,75,kWidth-Space*2,couponOut.contentHeight);
    _outBtn.hidden = NO;
    
    _price.textColor = [UIColor lightGrayColor];
    _mode.textColor = [UIColor lightGrayColor];
    _time.textColor = [UIColor lightGrayColor];
    _details.textColor = [UIColor lightGrayColor];
    _title.textColor  = [UIColor lightGrayColor];
    [self.contentView bringSubviewToFront:_outBtn];
    _cellHeight = CGRectGetMaxY(_details.frame);
}
@end
