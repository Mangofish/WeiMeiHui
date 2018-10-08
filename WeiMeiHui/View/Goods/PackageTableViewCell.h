//
//  PackageTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulesItem.h"
#import "TYAttributedLabel.h"

@interface PackageTableViewCell : UITableViewCell <TYAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;

@property (weak, nonatomic) IBOutlet UILabel *item;
@property (strong, nonatomic)  TYAttributedLabel *detail;


+(instancetype)packageTableViewCellOne;
+(instancetype)packageTableViewCellTwo;
+(instancetype)packageTableViewCellRemark;

@property(strong,nonatomic) RulesItem *goodsDetail;
@property(strong,nonatomic) RulesItem *needknow;

@property(assign,nonatomic) CGFloat cellHeight;

@end
