//
//  ShopWithAuthorsCollectionViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopWithAuthorsCollectionViewCell.h"

@implementation ShopWithAuthorsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self = [[NSBundle mainBundle] loadNibNamed:@"ShopWithAuthorsCollectionViewCell" owner:self options:nil][0];
        CGRect rect = CGRectMake(Space, 60, 85, 12);
        XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:rect];
        [self.contentView addSubview:starRateView];
        
        [starRateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(85));
            make.height.equalTo(@(12));
            make.centerX.mas_equalTo(self.contentView.mas_centerX).offset(0);
            make.top.mas_equalTo(self.nicknameLab.mas_bottom).offset(Space);
        }];
        
        self.starRateView = starRateView;
        self.starRateView.rateStyle = HalfStar;
        
        self.iconImg.layer.cornerRadius = 24;
        self.iconImg.layer.masksToBounds = YES;
        
        self.nicknameLab.layer.cornerRadius = 5;
        self.nicknameLab.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)setAuthor:(ShopAuthor *)author{
    
    [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:author.image] placeholderImage:[UIImage imageNamed:@"test"]];
    _nameLab.text = author.nickname;
    _nicknameLab.text = [NSString stringWithFormat:@" %@ ",author.grade_name];;
    _scoreLab.text = author.score;
    _orderLab.text = author.order_num;
    
    self.starRateView.currentScore = [author.score_show doubleValue];
    self.starRateView.userInteractionEnabled = NO;
    
    if ([author.is_attention integerValue] == 1) {
        _followBtn.selected = YES;
    }else{
        _followBtn.selected = NO;
    }
}


- (IBAction)followAction:(UIButton *)sender {
    
    [self.delegate followingAction:sender.tag];
    
}

@end
