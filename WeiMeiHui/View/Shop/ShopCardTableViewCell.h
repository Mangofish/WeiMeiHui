//
//  ShopCardTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCard.h"

@interface ShopCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *buyLab;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;

@property (weak, nonatomic) IBOutlet UILabel *title;

+ (instancetype)shopCardTableViewCell;

@property(strong,nonatomic) ShopCard *card;

@end
