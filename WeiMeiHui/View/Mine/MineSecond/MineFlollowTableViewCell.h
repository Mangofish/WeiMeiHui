//
//  MineFlollowTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineFollow.h"

@protocol MineFlollowTableViewCellDelegate <NSObject>


- (void)didClickFollowIndex:(NSInteger)index;

@end

@interface MineFlollowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *follow;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UILabel *work;
@property (weak, nonatomic) IBOutlet UIButton *isFollowBtn;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (nonatomic,   weak) id<MineFlollowTableViewCellDelegate> delegate;


@property (strong,nonatomic) MineFollow *followModel;
@property (strong,nonatomic) MineFollow *fansModel;

+(instancetype)mineFlollowTableViewCell;
+(instancetype)mineFlollowTableViewCellFans;
@end
