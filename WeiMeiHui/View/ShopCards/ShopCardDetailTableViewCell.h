//
//  ShopCardDetailTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAttributedLabel.h"
#import "ShopCardDetail.h"

@interface ShopCardDetailTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic)  TYAttributedLabel *conentLab;

@property (weak, nonatomic) IBOutlet UIImageView *erImg;

@property (weak, nonatomic) IBOutlet UILabel *inforLab;


+ (instancetype)shopCardDetailTableViewCell;
+ (instancetype)shopCardDetailTableViewCellEr;

@property(strong,nonatomic) ShopCardDetail *card;

@property(assign,nonatomic) float contentHeight;

@end
