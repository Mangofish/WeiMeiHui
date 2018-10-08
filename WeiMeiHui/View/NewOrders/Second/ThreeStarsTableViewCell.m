//
//  ThreeStarsTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ThreeStarsTableViewCell.h"

@implementation ThreeStarsTableViewCell

+(instancetype)threeStarView{
    
    ThreeStarsTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"ThreeStarsTableViewCell" owner:nil options:nil][0];
    
    cell.lab1.frame = CGRectMake(kWidth*18/75, 13, 60, 18);
    cell.lab2.frame = CGRectMake(kWidth*18/75, 13+Space+18, 60, 18);
    cell.lab3.frame = CGRectMake(kWidth*18/75, 13+Space*2+18*2, 60, 18);
    
    cell.starRateView1 = [[XHStarRateView alloc] initWithFrame:CGRectMake(kWidth*18/75+60, 13, 130, 20)];
    cell.starRateView1.isAnimation = YES;
    cell.starRateView1.rateStyle = HalfStar;
    cell.starRateView1.currentScore = 0;
    cell.starRateView1.delegate = cell;
    [cell.contentView addSubview:cell.starRateView1];
    
    cell.starRateView2 = [[XHStarRateView alloc] initWithFrame:CGRectMake(kWidth*18/75+60, 13+Space+18, 130, 20)];
    cell.starRateView2.isAnimation = YES;
    cell.starRateView2.rateStyle = HalfStar;
    cell.starRateView2.currentScore = 0;
    cell.starRateView2.delegate = cell;
    [cell.contentView addSubview:cell.starRateView2];
    
    cell.starRateView3 = [[XHStarRateView alloc] initWithFrame:CGRectMake(kWidth*18/75+60, 13+Space*2+18*2, 130, 20)];
    cell.starRateView3.isAnimation = YES;
    cell.starRateView3.rateStyle = HalfStar;
    cell.starRateView3.currentScore = 0;
    cell.starRateView3.delegate = cell;
    [cell.contentView addSubview:cell.starRateView3];
    
    return cell;
}

- (void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore {
    
    if (starRateView == self.starRateView1) {
        _score1 = currentScore;
    }
    
    if (starRateView == self.starRateView2) {
        _score2 = currentScore;
    }
    
    if (starRateView == self.starRateView3) {
        _score3 = currentScore;
    }
    
    [self.delegate didClickStarView:_score1 andScore:_score2 andScoreT:_score3];
    
}



@end
