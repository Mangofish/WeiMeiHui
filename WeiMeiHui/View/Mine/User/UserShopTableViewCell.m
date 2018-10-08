//
//  UserShopTableViewCell.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UserShopTableViewCell.h"

@interface UserShopTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *name;



@property (weak, nonatomic) IBOutlet UILabel *tagLab;

@end

@implementation UserShopTableViewCell

+(instancetype)userShopTableViewCell{
    
    return [[NSBundle mainBundle]loadNibNamed:@"UserShopTableViewCell" owner:nil options:nil][0];
    
}

+(instancetype)userShopTableViewPriceCell{
    UserShopTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"UserShopTableViewCell" owner:nil options:nil][1];
    cell.tagLab.layer.borderWidth = 1;
    cell.tagLab.layer.cornerRadius = 5;
    cell.tagLab.layer.masksToBounds = YES;
    cell.tagLab.layer.borderColor = MJRefreshColor(242, 177, 46).CGColor;
    return cell;
}

- (IBAction)telAction:(UIButton *)sender {
    [self.delegate didselectTel];
}

- (void)setModel:(ShopModel *)model{
    
    _model = model;
//    [_shopImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:model.shop_pic]];
    _name.text = model.shop_name;
    _address.text = model.shop_address;
//    _distance.text = [NSString stringWithFormat:@"营业时间：%@",model.openTime];

}



- (void)setModelShop:(ShopModel *)modelShop{
    
    _modelShop = modelShop;
//    [_shopImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:modelShop.pic]];
    _name.text = modelShop.shop_name;
    _address.text = modelShop.address;
//    _distance.text = [NSString stringWithFormat:@"营业时间：%@",modelShop.openTime];
    
}

- (void)setPriceAry:(NSArray *)priceAry{
    _priceAry = priceAry;
    for (int i = 0; i < priceAry.count; i++) {
        
        CGFloat width = kWidth/priceAry.count;
        CGFloat height = 44;
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake((i)*width, 0, width, height);
        [self.itemBgView addSubview:btn];
        [btn setTitle:[priceAry[i] objectForKey:@"tag_name"] forState:UIControlStateNormal];
        btn.tag = i+1;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]] ;
         [btn setTitleColor:MainColor forState:UIControlStateSelected];
        [btn setTitleColor:FontColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeItem:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
        }
    }
    
}
- (IBAction)locate:(UIButton *)sender {
    
    [self.delegate didselectLocation];
}
- (IBAction)mainAction:(UIButton *)sender {
    [self.delegate didselectMainPage];
}

- (void)changeItem:(UIButton *)sender{
    
    [self.delegate didselectItem:sender.tag];
    
}
@end
