//
//  GroupPayPageTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GroupPayPageTableViewCellDelegate <NSObject>

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

@property (weak, nonatomic) IBOutlet UILabel *stateLab;

+(instancetype)groupPayPageTableViewCellOne;
+(instancetype)groupPayPageTableViewCellTwo;
+(instancetype)groupPayPageTableViewCellThree;
+(instancetype)groupPayPageTableViewCellFour;
+(instancetype)groupPayPageTableViewCellFive;

@property (weak, nonatomic) id <GroupPayPageTableViewCellDelegate> delegate;

@end
