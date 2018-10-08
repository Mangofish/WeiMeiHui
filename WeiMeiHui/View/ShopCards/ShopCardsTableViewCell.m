//
//  ShopCardsTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopCardsTableViewCell.h"

@implementation ShopCardsTableViewCell


+(instancetype)shopCardsTableViewCell{
    
    return  [[NSBundle mainBundle] loadNibNamed:@"ShopCardsTableViewCell" owner:nil options:nil][0];
    
}

+(instancetype)shopCardsTableViewCellTwo{
    
    return  [[NSBundle mainBundle] loadNibNamed:@"ShopCardsTableViewCell" owner:nil options:nil][1];
    
}

- (void)setCard:(ShopCard *)card{
    
    _card = card;
    [_backImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:card.card_pic] placeholderImage:[UIImage imageNamed:@"test2"]];
    _nameLab.text = card.shop_name;
    _countLab.text = [NSString stringWithFormat:@"剩余剪发次数：%@",card.remainder];
    _timeLab.text = [NSString stringWithFormat:@"有效期：%@",card.end_time];
    _numberLab.text = [NSString stringWithFormat:@"No.%@",card.order_number];
    
    _backImg.layer.cornerRadius = 5;
    _backImg.layer.masksToBounds = YES;
    
    _buyBtn.layer.cornerRadius = 5;
    _buyBtn.layer.masksToBounds = YES;
    
}


@end
