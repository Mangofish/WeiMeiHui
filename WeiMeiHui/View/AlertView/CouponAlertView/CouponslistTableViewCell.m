//
//  CouponslistTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CouponslistTableViewCell.h"

@interface CouponslistTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *useIconBtn;

@property (strong, nonatomic)  UIImageView *seperateView;
@property (strong, nonatomic)  UIView *textBgView;

@end

@implementation CouponslistTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"CouponslistTableViewCell" owner:nil options:nil][0];
        [self customUI];
    }
    
    return self;
    
}

- (void)customUI{
    
    _moneyLab = [[TYAttributedLabel alloc]init];
    [self.contentView addSubview:_moneyLab];
    
    _moneyDetailLab = [[TYAttributedLabel alloc]init];
    [self.contentView addSubview:_moneyDetailLab];
    
    _timeLab = [[TYAttributedLabel alloc]init];
    [self.contentView addSubview:_timeLab];
    
    _titleLab = [[TYAttributedLabel alloc]init];
    [self.contentView addSubview:_titleLab];
    
    _contentLab = [[TYAttributedLabel alloc]init];
    [self.contentView addSubview:_contentLab];
 
    
    
    _useBtn.layer.cornerRadius =  5;
    _useBtn.layer.masksToBounds =  YES;
}

- (void)setCoupon:(CouponDown *)coupon{
    
    _coupon = coupon;
    
    _moneyLab.textContainer = coupon.moneyTextContainer;

    _moneyDetailLab.textContainer = coupon.detailTextContainer;
    _titleLab.textContainer = coupon.titleTextContainer;
    _timeLab.textContainer = coupon.timeTextContainer;

    
    _moneyLab.frame = CGRectMake(Space, 20, (kWidth-Space*3)/3-Space, coupon.moneyTextContainer.textHeight);
    _moneyDetailLab.frame = CGRectMake(Space, 30+coupon.moneyTextContainer.textHeight, (kWidth-Space*3)/3-Space, coupon.detailTextContainer.textHeight);
    
    _titleLab.frame = CGRectMake((kWidth-Space*2)/3 +Space , 20, kWidth - (kWidth-Space*2)/3 - Space*3, coupon.titleTextContainer.textHeight);
    _timeLab.frame = CGRectMake((kWidth-Space*2)/3 +Space , 25+coupon.titleTextContainer.textHeight, kWidth - (kWidth-Space*2)/3 - Space*3-72, coupon.timeTextContainer.textHeight);
    _detailBtn.frame = CGRectMake((kWidth-Space*2)/3-5, CGRectGetMaxY(_timeLab.frame), 97, 25);
    _useBtn.frame = CGRectMake(kWidth-Space*2-72, CGRectGetMaxY(_timeLab.frame), 72, 25);
    _lineView.frame = CGRectMake((kWidth-Space*2)/3, 20, 1,CGRectGetMaxY(_detailBtn.frame)-20);
    

    _detailBtn.tag = self.tag;
    _useBtn.tag = self.tag;
    
    if (coupon.isDown) {
        
        _textBgView = [[UIView alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(_detailBtn.frame)+Space, kWidth-Space*2, Space)];
        _textBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:_textBgView];
        
        _seperateView = [[UIImageView alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(_detailBtn.frame)+Space, kWidth-Space*2, Space)];
        [_seperateView setImage: [UIImage imageNamed:@"券分线"] ];
        [self.contentView addSubview:_seperateView];
        
        _contentLab.textContainer = coupon.textContainer;
        _contentLab.frame = CGRectMake(Space*2, CGRectGetMaxY(_seperateView.frame)+Space, (kWidth-Space*4), coupon.textContainer.textHeight);
        _cellHeight = CGRectGetMaxY(_contentLab.frame)+Space;
        
    }else{
        
        [_seperateView removeFromSuperview];
        [_textBgView removeFromSuperview];
        _cellHeight = CGRectGetMaxY(_detailBtn.frame)+Space;
        
    }
    
    if ([coupon.type integerValue] == 2 || [coupon.type integerValue] == 3) {
        _useBtn.hidden = NO;
    }else{
        _useBtn.hidden = YES;
    }
    
//    [self.contentView bringSubviewToFront:self.useIconBtn];
}

- (void)setOutcoupon:(CouponDown *)outcoupon{
    
    _outcoupon = outcoupon;
    
    _moneyLab.textContainer = outcoupon.moneyTextContainer;
    
    _moneyDetailLab.textContainer = outcoupon.detailTextContainer;
    _titleLab.textContainer = outcoupon.titleTextContainer;
    _timeLab.textContainer = outcoupon.timeTextContainer;
    
    _moneyLab.textContainer.textColor = LightFontColor;
    _timeLab.textContainer.textColor = LightFontColor;
    _titleLab.textContainer.textColor = LightFontColor;
    
    _moneyLab.frame = CGRectMake(Space, 20, (kWidth-Space*3)/3-Space, outcoupon.moneyTextContainer.textHeight);
    _moneyDetailLab.frame = CGRectMake(Space, 30+outcoupon.moneyTextContainer.textHeight, (kWidth-Space*4)/3-Space, outcoupon.detailTextContainer.textHeight);
    
    _titleLab.frame = CGRectMake((kWidth-Space*2)/3 +Space , 20, kWidth - (kWidth-Space*2)/3 - Space*3, outcoupon.titleTextContainer.textHeight);
    _timeLab.frame = CGRectMake((kWidth-Space*2)/3 +Space , 25+outcoupon.titleTextContainer.textHeight, kWidth - (kWidth-Space*2)/3 - Space*3-72, outcoupon.timeTextContainer.textHeight);
    _detailBtn.frame = CGRectMake((kWidth-Space*2)/3-5, CGRectGetMaxY(_timeLab.frame), 97, 25);
    _useBtn.hidden = YES;
    _useIconBtn.hidden = NO;
//    [self.contentView bringSubviewToFront:_useIconBtn];
    [_useIconBtn setImage:[UIImage imageNamed:@"已失效"] forState:UIControlStateNormal];
    
    _lineView.frame = CGRectMake((kWidth-Space*2)/3, 20, 1,CGRectGetMaxY(_detailBtn.frame)-20);
    _cellHeight = CGRectGetMaxY(_detailBtn.frame)+Space;
    
    _detailBtn.tag = self.tag;
    _useBtn.tag = self.tag;
    
    if (outcoupon.isDown) {
        
        _textBgView = [[UIView alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(_detailBtn.frame)+Space, kWidth-Space*2, Space)];
        _textBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:_textBgView];
        
        _seperateView = [[UIImageView alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(_detailBtn.frame)+Space, kWidth-Space*2, Space)];
        [_seperateView setImage: [UIImage imageNamed:@"券分线"]];
        [self.contentView addSubview:_seperateView];
        
        _contentLab.textContainer = outcoupon.textContainer;
        _contentLab.frame = CGRectMake(Space*2, CGRectGetMaxY(_seperateView.frame)+Space, (kWidth-Space*4), outcoupon.textContainer.textHeight);
        _cellHeight = CGRectGetMaxY(_contentLab.frame)+Space;
        
    }else{
        
        [_seperateView removeFromSuperview];
        [_textBgView removeFromSuperview];
        _cellHeight = CGRectGetMaxY(_detailBtn.frame)+Space;
        
    }
    
    [self.contentView bringSubviewToFront:_useIconBtn];
}

- (void)setLosecoupon:(CouponDown *)losecoupon{
    
    _losecoupon = losecoupon;
    
    _moneyLab.textContainer = losecoupon.moneyTextContainer;
    _moneyDetailLab.textContainer = losecoupon.detailTextContainer;
    _titleLab.textContainer = losecoupon.titleTextContainer;
    _timeLab.textContainer = losecoupon.timeTextContainer;
    
//    _moneyLab.textContainer.textColor = LightFontColor;
//    _timeLab.textContainer.textColor = LightFontColor;
//    _titleLab.textContainer.textColor = LightFontColor;
    
    _moneyLab.frame = CGRectMake(Space, 20, (kWidth-Space*3)/3-Space, losecoupon.moneyTextContainer.textHeight);
    _moneyDetailLab.frame = CGRectMake(Space, 30+losecoupon.moneyTextContainer.textHeight, (kWidth-Space*3)/3-Space, losecoupon.detailTextContainer.textHeight);
    
    _titleLab.frame = CGRectMake((kWidth-Space*2)/3 +Space , 20, kWidth - (kWidth-Space*2)/3 - Space*3, losecoupon.titleTextContainer.textHeight);
    _timeLab.frame = CGRectMake((kWidth-Space*2)/3 +Space , 25+losecoupon.titleTextContainer.textHeight, kWidth - (kWidth-Space*2)/3 - Space*3-72, losecoupon.timeTextContainer.textHeight);
    _detailBtn.frame = CGRectMake((kWidth-Space*2)/3-5, CGRectGetMaxY(_timeLab.frame), 97, 25);
    _useBtn.hidden = YES;
    _useIconBtn.hidden = NO;
//    [self.contentView bringSubviewToFront:_useIconBtn];
    [_useIconBtn setImage:[UIImage imageNamed:@"已使用"] forState:UIControlStateNormal];
    _lineView.frame = CGRectMake((kWidth-Space*2)/3, 20, 1,CGRectGetMaxY(_detailBtn.frame)-20);
    _cellHeight = CGRectGetMaxY(_detailBtn.frame)+Space;
    
    _detailBtn.tag = self.tag;
    _useBtn.tag = self.tag;
    
    if (losecoupon.isDown) {
        
        _textBgView = [[UIView alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(_detailBtn.frame)+Space, kWidth-Space*2, Space)];
        _textBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:_textBgView];
        
        _seperateView = [[UIImageView alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(_detailBtn.frame)+Space, kWidth-Space*2, Space)];
        [_seperateView setImage: [UIImage imageNamed:@"券分线"] ];
        [self.contentView addSubview:_seperateView];
        
        _contentLab.textContainer = losecoupon.textContainer;
        _contentLab.frame = CGRectMake(Space*2, CGRectGetMaxY(_seperateView.frame)+Space, (kWidth-Space*4), losecoupon.textContainer.textHeight);
        _cellHeight = CGRectGetMaxY(_contentLab.frame)+Space;
        
    }else{
        
        [_seperateView removeFromSuperview];
        [_textBgView removeFromSuperview];
        _cellHeight = CGRectGetMaxY(_detailBtn.frame)+Space;
        
    }
    
    [self.contentView bringSubviewToFront:_useIconBtn];
    
}

- (IBAction)inforAction:(UIButton *)sender {
    
    [self.delegate infoAction:sender];
    
}



- (IBAction)useAction:(UIButton *)sender {
    
    [self.delegate useCouponAction:sender];
    
}

@end
