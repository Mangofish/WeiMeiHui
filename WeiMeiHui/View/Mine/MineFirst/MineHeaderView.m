//
//  MineHeaderView.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/3/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *introLab;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *myworkLab;
@property (weak, nonatomic) IBOutlet UILabel *mycollectionLab;
@property (weak, nonatomic) IBOutlet UILabel *followLab;

@end



@implementation MineHeaderView
- (IBAction)iconAction:(UIButton *)sender {
    [self.delegate didClickIconBtn];
}

- (IBAction)collectionAction:(UIButton *)sender {
    [self.delegate didClickMenuIndex:4];
}
- (IBAction)natifyAction:(UIButton *)sender {
    [self.delegate didClickMenuIndex:3];
}
- (IBAction)commentAction:(UIButton *)sender {
    [self.delegate didClickMenuIndex:1];
}
- (IBAction)messageAction:(UIButton *)sender {
    [self.delegate didClickMenuIndex:2];
}

+(instancetype)headerViewWithFrame:(CGRect)frame{
    
    MineHeaderView *instabce = [[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:nil options:nil][0];
    instabce.frame = frame;
    instabce.layer.borderColor = [UIColor whiteColor].CGColor;
    instabce.layer.borderWidth = 2.0f;
    instabce.centLab.layer.borderWidth = 1.0f;
    instabce.centLab.layer.borderColor = [UIColor whiteColor].CGColor;
    
    instabce.redLab.layer.cornerRadius = 5;
    instabce.redLab.layer.masksToBounds = YES;
    
    return instabce;
    
}


+(instancetype)headerViewNotLogWithFrame:(CGRect)frame{
    
    MineHeaderView *instabce = [[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:nil options:nil][1];
    instabce.frame = frame;
//    instabce.layer.borderColor = [UIColor whiteColor].CGColor;
//    instabce.layer.borderWidth = 2.0f;
    
    instabce.centLab.layer.cornerRadius = 8.0f;
    instabce.centLab.layer.masksToBounds = YES;
    
    
    return instabce;
    
}


+(instancetype)headerViewLoginWithFrame:(CGRect)frame{
    
    MineHeaderView *instabce = [[NSBundle mainBundle] loadNibNamed:@"MineHeaderView" owner:nil options:nil][2];
    instabce.frame = frame;
//    instabce.layer.borderColor = [UIColor whiteColor].CGColor;
//    instabce.layer.borderWidth = 2.0f;
    
    instabce.centLab.layer.cornerRadius = 12.0f;
    instabce.centLab.layer.masksToBounds = YES;
    
  
    
    return instabce;
    
}

- (void)setAuthorUser:(WeiUserInfo *)authorUser{
    
    _centLab.hidden = NO;
    if (authorUser.image.length) {
        [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:authorUser.image]];
        [_bgImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:authorUser.image]];
    }
    
    _nameLab.text = authorUser.nickname;
    _introLab.text = authorUser.personal_sign;
    
    if (authorUser.fans_count.length) {
        _fansLab.hidden = NO;
        _fansLab.text = [NSString stringWithFormat:@"%@",authorUser.fans_count];
    }else{
        _fansLab.hidden = YES;
    }
    
    _mycollectionLab.text = [NSString stringWithFormat:@"%@",authorUser.collect_count];
    _myworkLab.text = [NSString stringWithFormat:@"%@",authorUser.send_count];
    _followLab.text = [NSString stringWithFormat:@"%@",authorUser.follow_count];
    
    [_centLab setTitle:[NSString stringWithFormat:@"资料完善度%@",authorUser.completeness] forState:UIControlStateNormal] ;
    
    if (authorUser.sex.length) {
        _sexBtn.hidden = NO;
        if ([authorUser.sex integerValue] == 1) {
            [_sexBtn setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
        }else{
            [_sexBtn setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
        }
    }else{
        
        _sexBtn.hidden = YES;
        
    }
    
    
    
    
}

- (void)setUser:(WeiUserInfo *)user{
    _user = user;
    
    _centLab.hidden = NO;
    if (user.image.length) {
         [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:user.image]];
//         [_bgImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:user.image]];
    }
   
    _nameLab.text = user.nickname;
    _introLab.text = user.personal_sign;
    if (user.fans_count.length) {
        _fansLab.hidden = NO;
        _fansLab.text = [NSString stringWithFormat:@"%@",user.fans_count];
    }else{
         _fansLab.hidden = YES;
    }
    
   _mycollectionLab.text = [NSString stringWithFormat:@"%@",user.collect_count];
    _myworkLab.text = [NSString stringWithFormat:@"%@",user.send_count];
    _followLab.text = [NSString stringWithFormat:@"%@",user.follow_count];
    
    [_centLab setTitle:[NSString stringWithFormat:@"资料完善度%@",user.completeness] forState:UIControlStateNormal] ;
    
    if (user.sex.length) {
        _sexBtn.hidden = NO;
        if ([user.sex integerValue] == 1) {
            [_sexBtn setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
        }else{
            [_sexBtn setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
        }
    }else{
        
        _sexBtn.hidden = YES;
        
    }
    
    
    
}

- (IBAction)fansAction:(UIButton *)sender {
    
    [self.delegate didClickFans];
    
}

- (IBAction)changeDataAction:(UIButton *)sender {
    [self.delegate didClickIconBtn];
}


- (IBAction)myWorkAction:(UIButton *)sender {
    
    [self.delegate didClickMenuIndex:1];
    
}

- (IBAction)myCollectionAction:(UIButton *)sender {
    
    [self.delegate didClickMenuIndex:2];
}

- (IBAction)myFansAction:(UIButton *)sender {
    
    [self.delegate didClickMenuIndex:4];
    
}
- (IBAction)myFollow:(UIButton *)sender {
    
     [self.delegate didClickMenuIndex:3];
    
}

- (IBAction)mySetting:(UIButton *)sender {
    [self.delegate didClickFans];
}
@end
