//
//  CardUseLogTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CardUseLogTableViewCell.h"

@implementation CardUseLogTableViewCell

+(instancetype)cardUseLogTableViewCell{
    
    return  [[NSBundle mainBundle] loadNibNamed:@"CardUseLogTableViewCell" owner:nil options:nil][0];
    
}

- (void)setCard:(ShopCardDetail *)card{
    
    _icon.layer.cornerRadius = 10;
    _icon.layer.masksToBounds = YES;
    
    _comment.layer.cornerRadius = 5;
    _comment.layer.masksToBounds = YES;
    
    [_icon sd_setImageWithURL:[NSURL urlWithNoBlankDataString:card.image] placeholderImage:[UIImage imageNamed:@"test"]];
    _name.text = card.nickname;
    _time.text = card.create_time;
    if ([card.status integerValue] == 0) {
        _comment.hidden = NO;
    }else{
        
        _comment.hidden = YES;
        
    }
    
}

@end
