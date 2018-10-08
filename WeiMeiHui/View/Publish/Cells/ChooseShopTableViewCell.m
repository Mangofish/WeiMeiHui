//
//  ChooseShopTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChooseShopTableViewCell.h"
#import "UIButton+ImageTitleSpacing.h"

@interface ChooseShopTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;

@end

@implementation ChooseShopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"ChooseShopTableViewCell" owner:self options:nil][0];
        
    }
    
    return self;
}

- (void)setShop:(ChooseShops *)shop{
    
    _shop = shop;
    _nameLab.text = shop.shop_name;
    _addressLab.text = shop.address;
    [_distanceBtn setTitle:shop.distance forState:UIControlStateNormal];
    
    [_distanceBtn setImage:[UIImage imageNamed:@"定位2"] forState:UIControlStateNormal];
    [_distanceBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    
    [_distanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
    }];
    
}


@end
