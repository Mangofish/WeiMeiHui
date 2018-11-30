//
//  CardsDoubleTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/11/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CardsDoubleTableViewCell.h"
#import "UIImage+QQCorner.h"

@implementation CardsDoubleTableViewCell

+ (instancetype)cardsDoubleTableViewCellDouble{
    
    CardsDoubleTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"CardsDoubleTableViewCell" owner:nil options:nil][0];
    [cell.imgLeft setImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        
        graColor.fromColor = MJRefreshColor(252, 142, 103);
        graColor.toColor = MJRefreshColor(255, 131, 85);
        graColor.type = QQGradualChangeTypeLeftToRight;
        
    } size:cell.imgLeft.bounds.size cornerRadius:QQRadiusMake(4, 4, 4, 4)]];
    
    [cell.imgRight setImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        
        graColor.fromColor = MJRefreshColor(251, 114, 101);
        graColor.toColor = MJRefreshColor(235, 71, 92);
        graColor.type = QQGradualChangeTypeLeftToRight;
        
    } size:cell.imgLeft.bounds.size cornerRadius:QQRadiusMake(4, 4, 4, 4)]];
    
    cell.buyLeft.layer.cornerRadius = 7;
    cell.buyLeft.layer.masksToBounds = YES;
    cell.buyLeft.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.buyLeft.layer.borderWidth = 1;
    
    cell.buyRight.layer.cornerRadius = 7;
    cell.buyRight.layer.masksToBounds = YES;
    cell.buyRight.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.buyRight.layer.borderWidth = 1;
    
    return cell;
}

+ (instancetype)cardsDoubleTableViewCellSingle{
    
    CardsDoubleTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"CardsDoubleTableViewCell" owner:nil options:nil][1];
    [cell.imgLeft setImage:[UIImage imageWithGradualChangingColor:^(QQGradualChangingColor *graColor) {
        
        graColor.fromColor = MJRefreshColor(252, 142, 103);
        graColor.toColor = MJRefreshColor(255, 131, 85);
        graColor.type = QQGradualChangeTypeLeftToRight;
        
    } size:cell.imgLeft.bounds.size cornerRadius:QQRadiusMake(4, 4, 4, 4)]];
    
   
    cell.buyLeft.layer.cornerRadius = 4;
    cell.buyLeft.layer.masksToBounds = YES;
    cell.buyLeft.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.buyLeft.layer.borderWidth = 1;
    
    return cell;
}

- (void)setCardLeft:(ShopCard *)cardLeft{
    
    _cardLeft = cardLeft;
   
    _nameLeft.text = cardLeft.card_name;
    _introLeft.text = cardLeft.gift;
    _priceLeft.text = cardLeft.price;
    
    _leftBtn.tag = self.tag;
   _rightBtn.tag = self.tag;
    
}

- (void)setCardright:(ShopCard *)cardright{
    
    _cardright = cardright;
    
    _nameRight.text = cardright.card_name;
    _introRight.text = cardright.gift;
    _priceRight.text = cardright.price;
    
    _leftBtn.tag = self.tag;
    _rightBtn.tag = self.tag;
    
}

- (IBAction)leftAction:(UIButton *)sender {
    
    [self.delegate leftOrRightAtIndex:0 andCellIndex:self.tag];
    
}

- (IBAction)rightAction:(UIButton *)sender {
    
   [self.delegate leftOrRightAtIndex:1 andCellIndex:self.tag];
    
}

@end
