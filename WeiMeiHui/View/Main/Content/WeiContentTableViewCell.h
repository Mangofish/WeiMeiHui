//
//  WeiContentTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiContent.h"

@protocol WeiContentCellDelegate <NSObject>

- (void)moreBtnAction:(UIButton *)sender;
- (void)playBtnAction:(UIButton *)sender;
- (void)chooseZan:(UIButton *)sender;
- (void)chooseComment:(UIButton *)sender;
- (void)chooseMessege:(UIButton *)sender;
- (void)chooseIcon:(UIButton *)sender;
- (void)chooseShopAddress:(UIButton *)sender;
- (void)chooseDel:(UIButton *)sender;
@end

@interface WeiContentTableViewCell : UITableViewCell

@property(strong,nonatomic)WeiContent *homeCellViewModel;

@property(assign,nonatomic)CGFloat cellHeight;

@property (nonatomic, weak) id<WeiContentCellDelegate> delegate;

@property(strong,nonatomic)UIButton *playBtn;

@property(assign,nonatomic)BOOL isDel;

@end
