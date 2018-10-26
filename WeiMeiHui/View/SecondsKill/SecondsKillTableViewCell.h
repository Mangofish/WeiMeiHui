//
//  SecondsKillTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYLineProgressView.h"
#import "SecondKillGoods.h"

@protocol SecondsKillTableViewCellDelegate <NSObject>

- (void)didClickMenuIndex:(NSInteger)index;
- (void)didClickBuyIndex:(NSInteger)index;

@end

@interface SecondsKillTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIImageView *tagImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *shopLab;
@property (weak, nonatomic) IBOutlet UILabel *peiceLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (strong, nonatomic)  ZYLineProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *remindBtn;

@property (strong, nonatomic)  SecondKillGoods *goods;
@property (weak, nonatomic) IBOutlet UILabel *orgPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (nonatomic,   weak) id<SecondsKillTableViewCellDelegate> delegate;

+(instancetype)secondsKillTableViewCell;
+(instancetype)secondsKillTableViewCellSold;
+(instancetype)secondsKillTableViewCellRemind;
+(instancetype)secondsKillTableViewCellCancel;

@end
