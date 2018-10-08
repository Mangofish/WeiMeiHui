//
//  NormalAuthorDEtailTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "NormalAuthorDEtailTableViewCell.h"

@interface NormalAuthorDEtailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceWei;
@property (weak, nonatomic) IBOutlet UILabel *acName;
@property (weak, nonatomic) IBOutlet UILabel *scPrice;
@property (weak, nonatomic) IBOutlet UILabel *givePrice;
@property (weak, nonatomic) IBOutlet UILabel *income;

@property (weak, nonatomic) IBOutlet UILabel *oriPrice;
@property (weak, nonatomic) IBOutlet UILabel *disPrice;

@property (weak, nonatomic) IBOutlet UILabel *incomePrice;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@end

@implementation NormalAuthorDEtailTableViewCell

+ (instancetype)normalAuthorDEtailTableViewCell{
    
    NormalAuthorDEtailTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NormalAuthorDEtailTableViewCell" owner:nil options:nil][0];
    
    return cell;
}

+ (instancetype)normalAuthorDEtailTableViewCellTwo{
    
    NormalAuthorDEtailTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NormalAuthorDEtailTableViewCell" owner:nil options:nil][1];
    
    return cell;
}

+ (instancetype)normalAuthorDEtailTableViewCellFooter{
    
    NormalAuthorDEtailTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"NormalAuthorDEtailTableViewCell" owner:nil options:nil][2];
    cell.inviteBtn.layer.cornerRadius = 4;
    cell.inviteBtn.layer.masksToBounds = YES;
    cell.inviteBtn.layer.borderColor = MainColor.CGColor;
    cell.inviteBtn.layer.borderWidth = 1.0f;
    return cell;
}


- (void)setComment:(OrderComment *)comment{
    
    _priceWei.text = comment.org_price;
    _disPrice.text = comment.par_value;
    _incomePrice.text = comment.price;
    _givePrice.text = comment.shop_subsidy;
    _income.text = comment.price;
    _scPrice.text = comment.activityPrice;
    _acName.text = comment.activity_name;
    _oriPrice.text = comment.org_price;
}
@end
