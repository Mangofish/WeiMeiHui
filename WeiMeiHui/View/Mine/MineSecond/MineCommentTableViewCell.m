//
//  MineCommentTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MineCommentTableViewCell.h"
#import "UIButton+WebCache.h"

@implementation MineCommentTableViewCell

+(instancetype)mineCommentTableViewCell{
    return [[NSBundle mainBundle] loadNibNamed:@"MineCommentTableViewCell" owner:self options:nil][0];
}

- (void)setComment:(MineComment *)comment{
    
    _comment = comment;
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:comment.image] forState:UIControlStateNormal];
    _nameLab.text = comment.nickname;
    _timeLab.text = comment.create_time;
    [_workImg sd_setImageWithURL:[NSURL URLWithString:comment.pic] forState:UIControlStateNormal];
    
}

- (IBAction)iconBtn:(UIButton *)sender {
    
    [self.delegate didClickIcon:sender.tag];
    
}
@end
