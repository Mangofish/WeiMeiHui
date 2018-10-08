//
//  ActivityThreeTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityThreeTableViewCellDelegate <NSObject>

- (void)selectImg:(NSUInteger)index;

@end


@interface ActivityThreeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *singleImg;

@property (weak, nonatomic) IBOutlet UIImageView *rightTwo;

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightOne;
@property (weak, nonatomic) IBOutlet UIButton *rightOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property(weak,nonatomic)id <ActivityThreeTableViewCellDelegate>delegate;

+(instancetype)activityThreeTableViewCellSingle;
+(instancetype)activityThreeTableViewCellThree;
+(instancetype)activityThreeTableViewCellThreeMain;
+(instancetype)activityThreeTableViewCellSingleMain;

@end
