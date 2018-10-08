//
//  CardUseLogTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCardDetail.h"

@interface CardUseLogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *comment;

+ (instancetype)cardUseLogTableViewCell;

@property(strong,nonatomic) ShopCardDetail *card;

@end
