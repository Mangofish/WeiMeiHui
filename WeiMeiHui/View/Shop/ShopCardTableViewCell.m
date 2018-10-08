//
//  ShopCardTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopCardTableViewCell.h"

@implementation ShopCardTableViewCell

+(instancetype)shopCardTableViewCell{
    
  return  [[NSBundle mainBundle] loadNibNamed:@"ShopCardTableViewCell" owner:nil options:nil][0];
    
}

- (void)setCard:(ShopCard *)card{
    
    _card = card;
    [_backImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:card.pic_back] placeholderImage:[UIImage imageNamed:@"test2"]];
    _title.text = card.card_name;
    _detailLab.text = card.gift;
    _priceLab.text = card.card_price;
    _numLab.text = card.pay_count;
    _buyLab.layer.cornerRadius = 12;
    _buyLab.layer.masksToBounds = YES;
    _backImg.layer.cornerRadius = 5;
    _backImg.layer.masksToBounds = YES;
}

@end
