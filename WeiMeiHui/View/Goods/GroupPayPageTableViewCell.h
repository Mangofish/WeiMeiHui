//
//  GroupPayPageTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAttributedLabel.h"

@protocol GroupPayPageTableViewCellDelegate <NSObject>

@optional

- (void) didSelectedItemAtIndex:(NSUInteger)index;
- (void) plus;
- (void) decrese;

@end

@interface GroupPayPageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *detailsLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *leftMoney;
@property (weak, nonatomic) IBOutlet UIView *bgView7;

@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@property (strong, nonatomic)   TYAttributedLabel*explainLab;

+(instancetype)groupPayPageTableViewCellOne;
+(instancetype)groupPayPageTableViewCellTwo;
+(instancetype)groupPayPageTableViewCellThree;
+(instancetype)groupPayPageTableViewCellFour;
+(instancetype)groupPayPageTableViewCellFive;
+(instancetype)groupPayPageTableViewCellSix;
+(instancetype)groupPayPageTableViewCellSeven;
+(instancetype)groupPayPageTableViewCellEight;
+(instancetype)groupPayPageTableViewCellNight;
+(instancetype)groupPayPageTableViewCellTen;

@property (weak, nonatomic) id <GroupPayPageTableViewCellDelegate> delegate;
@property (assign, nonatomic)  CGFloat cellHeight;

@end
