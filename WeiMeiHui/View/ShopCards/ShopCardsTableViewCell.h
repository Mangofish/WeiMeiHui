//
//  ShopCardsTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCard.h"

@interface ShopCardsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIImageView *singleImg;

+ (instancetype)shopCardsTableViewCell;
+ (instancetype)shopCardsTableViewCellTwo;

@property(strong,nonatomic) ShopCard *card;



@end
