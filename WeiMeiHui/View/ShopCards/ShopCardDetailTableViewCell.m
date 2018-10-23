//
//  ShopCardDetailTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopCardDetailTableViewCell.h"



@implementation ShopCardDetailTableViewCell

+(instancetype)shopCardDetailTableViewCell{
    
    return  [[NSBundle mainBundle] loadNibNamed:@"ShopCardDetailTableViewCell" owner:nil options:nil][1];
    
}

+(instancetype)shopCardDetailTableViewCellEr{
    
    return  [[NSBundle mainBundle] loadNibNamed:@"ShopCardDetailTableViewCell" owner:nil options:nil][0];
    
}

- (void)setCard:(ShopCardDetail *)card{
    
    _card = card;
    
    [_erImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:card.qrcode] placeholderImage:[UIImage imageNamed:@"test2"]];
//    _inforLab.text = card.use_note;
    
    _titleLab.frame = CGRectMake(Space,Space,65,20);
    
    _conentLab = [[TYAttributedLabel alloc]init];
    [self.contentView addSubview:_conentLab];
    
     _conentLab.frame = CGRectMake(65+Space*2,Space,kWidth-CELL_SIDEMARGIN*3-65,0);
    
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing = 4;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:12];
    textContainer.text = card.card_summary;
    textContainer.textColor =FontColor;
    textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*3-65];
    
    _conentLab.textContainer = textContainer;
    
    _conentLab.frame = CGRectMake(65+Space*2,Space,kWidth-CELL_SIDEMARGIN*3-65,textContainer.textHeight);
    _contentHeight = textContainer.textHeight+Space*2;
}


- (IBAction)seeBtn:(UIButton *)sender {
    [self.delegate didClickMenu];
}

@end
