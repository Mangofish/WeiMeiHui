//
//  UserHeaderView.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "NormalUserHeaderView.h"
@interface NormalUserHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *followFansLab;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
@implementation NormalUserHeaderView

+(instancetype)userHeaderViewWithFrame:(CGRect)frame{
    NormalUserHeaderView *instance = [[NSBundle mainBundle] loadNibNamed:@"NormalUserHeaderView" owner:nil options:nil][0];
    instance.frame = frame;
    CGFloat width = (kWidth-Space*2-5*3)/4;
    [instance.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(instance).offset(0);
        make.height.equalTo(@(width));
        make.bottom.equalTo(instance.mas_bottom).offset(-Space);
    }];
    
    [instance.img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(instance).offset(Space);
        make.height.width.equalTo(@(width));
        make.bottom.equalTo(instance.bottomView).offset(0);
    }];
    
    [instance.img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(instance.img1.mas_right).offset(5);
        make.height.width.equalTo(@(width));
        make.bottom.equalTo(instance.bottomView).offset(0);
    }];
    
    [instance.img3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(instance.img2.mas_right).offset(5);
        make.height.width.equalTo(@(width));
        make.bottom.equalTo(instance.bottomView).offset(0);
    }];
    
    [instance.img4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(instance.img3.mas_right).offset(5);
        make.height.width.equalTo(@(width));
        make.bottom.equalTo(instance.bottomView).offset(0);
    }];
    
    return instance;
}

+ (instancetype)userHeadView{
    
   return  [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil][1];
    
}

- (void)setHomeCellViewModel:(UserHeader *)homeCellViewModel{
    
    _homeCellViewModel = homeCellViewModel;
    if (homeCellViewModel.image.length) {
        [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:homeCellViewModel.image] placeholderImage:[UIImage imageNamed:@"test.png"]];
        [_bgImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:homeCellViewModel.image] placeholderImage:[UIImage imageNamed:@"test.png"]];
    }else{
        _iconImg.image = [UIImage imageNamed:@"test.png"];
        _bgImg.image = [UIImage imageNamed:@"test2.png"];
    }
    
    _nameLabel.text = homeCellViewModel.nickname;
    _introLabel.text = homeCellViewModel.intro;
    _followFansLab.text = [NSString stringWithFormat:@"关注   %@  粉丝  %@",homeCellViewModel.attention_count,homeCellViewModel.fans_count];
    
    
}
@end
