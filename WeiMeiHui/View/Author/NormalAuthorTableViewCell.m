//
//  NormalAuthorTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "NormalAuthorTableViewCell.h"

@interface NormalAuthorTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNum;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation NormalAuthorTableViewCell

+ (instancetype)normalAuthorTableViewCell{
    
    NormalAuthorTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NormalAuthorTableViewCell" owner:nil options:nil][0];
    cell.frame = CGRectMake(0, 0, kWidth, 134);
    
    return cell;
}

- (void)setAuthor:(AuthorOrdersModel *)author{
    
    _nameLab.text = author.nickname;
    _timeLab.text = author.create_time;
    _titleLab.text = author.title;
    _orderNum.text = author.order_number;
    _priceLab.text = [NSString stringWithFormat:@"订单收入：¥%@",author.price];
    
}

- (void)setAuthorDetail:(AuthorOrdersModel *)authorDetail{
    
    _nameLab.text = authorDetail.nickname;
    _timeLab.text = authorDetail.create_time;
    _titleLab.text = authorDetail.title;
    _orderNum.text = authorDetail.order_number;
    _priceLab.hidden = YES;
    
}

@end
