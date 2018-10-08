//
//  MineFlollowTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MineFlollowTableViewCell.h"
#import "UIButton+WebCache.h"

@implementation MineFlollowTableViewCell

+(instancetype)mineFlollowTableViewCell{
    return [[NSBundle mainBundle] loadNibNamed:@"MineFlollowTableViewCell" owner:self options:nil][0];
}

+(instancetype)mineFlollowTableViewCellFans{
    return [[NSBundle mainBundle] loadNibNamed:@"MineFlollowTableViewCell" owner:self options:nil][1];
}


- (void)setFollowModel:(MineFollow *)followModel{
    
    _followModel = followModel;
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:followModel.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"test"]];
    _name.text = followModel.nickname;
    _follow.text = followModel.follow_count;
    _fans.text = followModel.fans_count;
    _work.text = followModel.send_count;
    
//    互相关注
    if ([followModel.is_mutual integerValue] == 1) {
         [_isFollowBtn setImage:[UIImage imageNamed:@"互相关注"] forState:UIControlStateNormal];
    }else{
         [_isFollowBtn setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
    }
    
    //    手艺人
    if ([followModel.level integerValue] == 2) {
        
        _name.textColor = MainColor;
        _nickName.hidden = NO;
        
    }else{
        
        _nickName.hidden = YES;
        
    }
    
    _nickName.text = [NSString stringWithFormat:@" %@  ",followModel.grade];
    _nickName.layer.masksToBounds = YES;
    _nickName.layer.cornerRadius = 8;
    _isFollowBtn.tag = self.tag;
    
}

- (void)setFansModel:(MineFollow *)fansModel{
    
    _fansModel = fansModel;
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:fansModel.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"test"]];
    _name.text = fansModel.nickname;
    _follow.text = fansModel.follow_count;
    _fans.text = fansModel.fans_count;
    _work.text = fansModel.send_count;
    
    if ([fansModel.is_mutual integerValue] == 1) {
         [_isFollowBtn setImage:[UIImage imageNamed:@"互相关注"] forState:UIControlStateNormal];
        
    }else{
        [_isFollowBtn setImage:[UIImage imageNamed:@"关注红"] forState:UIControlStateNormal];
        
    }
    
//    手艺人
    if ([fansModel.level integerValue] == 2) {
        
         _name.textColor = MainColor;
        _nickName.hidden = NO;
        
    }else{
        
        _nickName.hidden = YES;
        
    }
    
    _nickName.text = [NSString stringWithFormat:@" %@  ",fansModel.grade];
    _nickName.layer.masksToBounds = YES;
    _nickName.layer.cornerRadius = 8;
    
    _isFollowBtn.tag = self.tag;
    
}


- (IBAction)followAction:(UIButton *)sender {
    
    
    
    [self.delegate didClickFollowIndex:sender.tag];
    
}

- (IBAction)fansAction:(UIButton *)sender {
    
    
    
    [self.delegate didClickFollowIndex:sender.tag];
    
}
@end
