//
//  MineCommentTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineComment.h"

@protocol CommentCellDelegate <NSObject>

@optional
- (void)didClickIcon:(NSInteger)index;

@end

@interface MineCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *workImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak,nonatomic) id <CommentCellDelegate>delegate;

@property (strong,nonatomic) MineComment *comment;

+(instancetype)mineCommentTableViewCell;



@end
