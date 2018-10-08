//
//  ThreeStarsTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@protocol ThreeStarsDelegate <NSObject>

- (void)didClickStarView:(CGFloat)scoreOne andScore:(CGFloat)scoreTwo andScoreT:(CGFloat)scoreThree;

@end

@interface ThreeStarsTableViewCell : UITableViewCell <XHStarRateViewDelegate>

@property (strong, nonatomic) XHStarRateView *starRateView1;
@property (strong, nonatomic) XHStarRateView *starRateView2;
@property (strong, nonatomic) XHStarRateView *starRateView3;

@property (weak, nonatomic) IBOutlet UILabel *lab1;

@property (weak, nonatomic) IBOutlet UILabel *lab2;

@property (weak, nonatomic) IBOutlet UILabel *lab3;

@property (nonatomic, assign) CGFloat score1;
@property (nonatomic, assign) CGFloat score2;
@property (nonatomic, assign) CGFloat score3;

@property (nonatomic, weak) id <ThreeStarsDelegate> delegate ;

+(instancetype)threeStarView;

@end
