//
//  WeiAdvertTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiContent.h" 

@protocol WeiAdvertTableViewCellDelegate <NSObject>

- (void)moreBtnActionA:(UIButton *)sender;
- (void)chooseIconA:(UIButton *)sender;

@end

@interface WeiAdvertTableViewCell : UITableViewCell

@property(strong,nonatomic)WeiContent *homeCellViewModel;

@property(assign,nonatomic)CGFloat cellHeight;

@property (nonatomic, weak) id<WeiAdvertTableViewCellDelegate> delegate;

@end
