//
//  PickAwardsTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickAwardsTableViewCellDelegate <NSObject>

- (void)takeAwards:(NSString *)couponID;

@end

@interface PickAwardsTableViewCell : UITableViewCell

+(instancetype)activityThreeTableViewCellPick;
+(instancetype)activityThreeTableViewCellFriend;
+(instancetype)activityThreeTableViewCellRecord;
+(instancetype)activityThreeTableViewCellChance;

@property (copy, nonatomic) NSArray *dataAry;

@property (copy, nonatomic) NSDictionary *recordDic;
@property (copy, nonatomic) NSDictionary *friendsDic;
@property (weak, nonatomic) IBOutlet UILabel *titleChance;
@property (weak, nonatomic) IBOutlet UIButton *chanceBtn;

@property (weak, nonatomic) id <PickAwardsTableViewCellDelegate> delegate;

@end
