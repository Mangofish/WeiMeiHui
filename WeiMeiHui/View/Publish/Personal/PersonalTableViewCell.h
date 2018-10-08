//
//  PersonalTableViewCell.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GBTagListView.h"


@protocol PersonalTableViewCellDelegate <NSObject>

//- (void)moreBtnAction:(UIButton *)sender;
//- (void)playBtnAction:(UIButton *)sender;
//- (void)chooseZan:(UIButton *)sender;

@optional
- (void)chooseAddPic;
- (void)chooseLookPic:(NSUInteger)index;
- (void)chooseDelPic:(NSUInteger)index;
- (void)chooseSex:(NSUInteger)index;
- (void)chooseServiceAry:(NSArray *)data;

@end


@interface PersonalTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *countLab;


@property (strong, nonatomic) GBTagListView *bubbleView;
@property (strong, nonatomic) GBTagListView *sexBubbleView;

@property (weak, nonatomic) IBOutlet UILabel *serviceLab;
@property (weak, nonatomic) IBOutlet UILabel *rangLab;

@property (strong, nonatomic)  UITextView *noteTF;

@property (assign,nonatomic) NSUInteger type;

@property (copy,nonatomic) NSString *stateStr;

@property (nonatomic, weak) id<PersonalTableViewCellDelegate> delegate;




+(instancetype)personalTableViewCellOne;
+(instancetype)personalTableViewCellTwo;
+(instancetype)personalTableViewCellThreeWithString:(NSString *)str;
+(instancetype)personalTableViewCellFour;


@property (copy, nonatomic) NSArray *tagAry;
@property (copy, nonatomic) NSArray *sextagAry;
@property (strong, nonatomic) NSMutableArray *selectedAry;
@property (strong, nonatomic) NSMutableArray *selectedAsset;
@property (assign, nonatomic) float cellHeight;

@end
