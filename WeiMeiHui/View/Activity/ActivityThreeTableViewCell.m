//
//  ActivityThreeTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ActivityThreeTableViewCell.h"


@implementation ActivityThreeTableViewCell

+(instancetype)activityThreeTableViewCellSingle{
    
    ActivityThreeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ActivityThreeTableViewCell" owner:self options:nil][0];
    return cell;
    
}

+(instancetype)activityThreeTableViewCellSingleMain{
    
    ActivityThreeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ActivityThreeTableViewCell" owner:self options:nil][2];
    return cell;
    
}


+(instancetype)activityThreeTableViewCellThree{
    
    ActivityThreeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ActivityThreeTableViewCell" owner:self options:nil][1];
    cell.leftImg.frame = CGRectMake(Space, Space, kWidth*180/(375-Space*3), kHeight*134/667);
    cell.leftImg.layer.masksToBounds = YES;
    cell.rightOne.frame = CGRectMake(Space*2 + kWidth*180/(375-Space*3), Space, (kWidth-Space*3)*165/375, kHeight*62/667);
    cell.rightOne.layer.masksToBounds = YES;

    cell.rightTwo.frame = CGRectMake(Space*2 + kWidth*180/(375-Space*3), Space*2+kHeight*62/667, (kWidth-Space*3)*165/375, kHeight*62/667);
    
//
    cell.leftBtn.frame = cell.leftImg.frame;
    cell.rightOneBtn.frame = cell.rightOne.frame;
    cell.rightTwoBtn.frame = cell.rightTwo.frame;
    
    if (k_iPhoneX) {
        cell.rightOne.contentMode = UIViewContentModeScaleToFill;
        cell.rightTwo.contentMode = UIViewContentModeScaleToFill;
    }
    
    cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return cell;
    
}

+(instancetype)activityThreeTableViewCellThreeMain{
    
    ActivityThreeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ActivityThreeTableViewCell" owner:self options:nil][1];
    
    cell.leftImg.frame = CGRectMake(Space, Space, kWidth*175/(375-Space*3), kHeight*134/667);
    cell.leftImg.layer.masksToBounds = YES;
    
    cell.rightOne.frame = CGRectMake(Space*2 + kWidth*175/(375-Space*3), Space, (kWidth-Space*3)*170/375, kHeight*62/667);
    cell.rightOne.layer.masksToBounds = YES;
    
    cell.rightTwo.frame = CGRectMake(Space*2 + kWidth*175/(375-Space*3), Space*2+kHeight*62/667, (kWidth-Space*3)*170/375, kHeight*62/667);
    
    //
    cell.leftBtn.frame = cell.leftImg.frame;
    cell.rightOneBtn.frame = cell.rightOne.frame;
    cell.rightTwoBtn.frame = cell.rightTwo.frame;
    
    if (k_iPhoneX) {
        cell.rightOne.contentMode = UIViewContentModeScaleToFill;
        cell.rightTwo.contentMode = UIViewContentModeScaleToFill;
    }
    
    return cell;
    
}


- (IBAction)leftAction:(UIButton *)sender {
    [self.delegate selectImg:sender.tag];
}
- (IBAction)rightAction:(UIButton *)sender {
    
     [self.delegate selectImg:sender.tag];
}

@end
