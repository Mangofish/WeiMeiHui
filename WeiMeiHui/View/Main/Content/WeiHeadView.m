//
//  WeiHeadView.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiHeadView.h"
#import "UIView+ShortCut.h"
#import "UIButton+WebCache.h"

//布局字体
#define TITLE_FONT_SIZE [UIFont systemFontOfSize:16.f]
#define SUBTITLE_FONT_SIZE [UIFont systemFontOfSize:12.f]
#define BUTTON_FONT_SIZE [UIFont systemFontOfSize:13.f]
//头部固定高度
#define HEAD_HEIGHT  55.0f
#define HEAD_CONTACTAVATARVIEW_HEIGHT 40.0f
#define HEAD_IAMGE_HEIGHT  40.0f

@interface WeiHeadView()
{
//    UIButton *_contactAvatarView;//头像大view
    UIImageView *_imgAvatarView;//头像
    UILabel *_btnUserScreenName;//称号图标
    UILabel *_labUserName;//用户昵称
    UIImageView *_imgVip;//Vip图标
//    UIButton *_moreBtn;//更多
//    UILabel *_time;
}
@end

@implementation WeiHeadView

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        self.backgroundColor=[UIColor whiteColor];
        [self configurationContentView];
        
    }
    return self;
}

#pragma 配置view
-(void)configurationContentView
{
    //头像View
    _contactAvatarView=[[UIButton alloc]init];
    [_contactAvatarView addTarget:self action:@selector(iconAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_contactAvatarView];
    
    
    //头像
    _imgAvatarView=[[UIImageView alloc]init];
    _imgAvatarView.contentMode = UIViewContentModeScaleAspectFill;
    _imgAvatarView.layer.cornerRadius = HEAD_IAMGE_HEIGHT/2;
    _imgAvatarView.layer.masksToBounds = YES;
    [_contactAvatarView addSubview:_imgAvatarView];
    
    
    //VIp
    _imgVip=[[UIImageView alloc]init];
//    _imgVip.backgroundColor=[UIColor clearColor];
//    _imgVip.image=[UIImage imageNamed:@"common_icon_membership"];
    [_contactAvatarView addSubview:_imgVip];
    
    //用户昵称
    _labUserName=[[UILabel alloc]init];
    _labUserName.font = TITLE_FONT_SIZE;
    _labUserName.textColor=[UIColor redColor];
    [self addSubview:_labUserName];
    
    //称号
    _btnUserScreenName=[[UILabel alloc]init];
    _btnUserScreenName.backgroundColor=MainColor;
    _btnUserScreenName.textColor = [UIColor whiteColor];
    _btnUserScreenName.layer.cornerRadius = 5;
    _btnUserScreenName.layer.masksToBounds = YES;
    _btnUserScreenName.font = [UIFont systemFontOfSize:10];
    _btnUserScreenName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_btnUserScreenName];

    //图标
    _moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.backgroundColor=[UIColor clearColor];
    
    [self addSubview:_moreBtn];
    
    
}

#pragma mark － 配置位置
-(void)configurationLocation
{
    if (_homeCellViewModel) {
         _labUserName.frame=CGRectMake(63,20,_homeCellViewModel.nameWidth,20);
    }else{
        _labUserName.frame=CGRectMake(63,20,_model.nameWidth,20);
    } _contactAvatarView.frame=CGRectMake(CELL_SIDEMARGIN,CELL_SIDEMARGIN,HEAD_CONTACTAVATARVIEW_HEIGHT,HEAD_CONTACTAVATARVIEW_HEIGHT);
     _imgAvatarView.frame=CGRectMake(0,0,HEAD_IAMGE_HEIGHT,HEAD_IAMGE_HEIGHT);
    _imgVip.frame=CGRectMake(40-14,40-14,14,14);
    
    _btnUserScreenName.frame=CGRectMake(CGRectGetMaxX(_labUserName.frame)+Space,20,_homeCellViewModel.nickWidth,20);
    
    if (_homeCellViewModel) {
        [_moreBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(40));
            make.height.equalTo(@(20));
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.centerY.mas_equalTo(self->_imgAvatarView.mas_centerY).offset(0);
        }];
        
        [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self->_model.createTimeWidth+Space));
            make.height.equalTo(@(20));
            make.right.mas_equalTo(self.mas_right).offset(-Space);
            make.centerY.mas_equalTo(self->_imgAvatarView.mas_centerY).offset(0);
        }];
        [_moreBtn setTitleColor:MJRefreshColor(102, 102, 102) forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn setTitle:_model.create_time forState:UIControlStateNormal];
        
    }
    
    
    
}

- (void)iconAction:(UIButton *)sender{
    
    [self.delegate  didSelectedIconBtn:sender];
    
    [self.commentdelegate didSelectedIconBtn:sender];
    
}

- (void)moreAction:(UIButton *)sender{
    [self.delegate  didSelectedMoreBtn:sender];
}

-(void)setHomeCellViewModel:(WeiContent *)homeCellViewModel
{
    _homeCellViewModel = homeCellViewModel;
    
    if (homeCellViewModel.image.length) {
        [_imgAvatarView sd_setImageWithURL:[NSURL urlWithNoBlankDataString:homeCellViewModel.image] placeholderImage:nil options:SDWebImageLowPriority];
    }else{
        _imgAvatarView.image = [UIImage imageNamed:@"test.png"];
    }
    
    if (homeCellViewModel.grade_name.length) {
        _btnUserScreenName.hidden = NO;
        
    }else{
        _btnUserScreenName.hidden = YES;
    }
    _btnUserScreenName.text = homeCellViewModel.grade_name;
    
    if ([homeCellViewModel.level integerValue] == 3) {
        _labUserName.textColor = FontColor;
    }

    if ([homeCellViewModel.is_advertise integerValue] == 1) {
        _btnUserScreenName.backgroundColor = MJRefreshColor(235, 91, 175);
    }
    
    _imgVip.hidden = NO;
    _imgVip.image = [UIImage imageNamed:[NSString stringWithFormat:@"认证%@",homeCellViewModel.grade]];
    
   
    
    _labUserName.text = homeCellViewModel.nickname;
    
    _labUserName.width = homeCellViewModel.nameWidth;
    _imgVip.left=_labUserName.right+3;
    _btnUserScreenName.width = _btnUserScreenName.width;
//    _btnUserScreenName.text = homeCellViewModel.grade_name;
    [self configurationLocation];
}

- (void)setModel:(CommentList *)model{
 
    _model = model;

    if (model.image.length) {
        [_imgAvatarView sd_setImageWithURL:[NSURL urlWithNoBlankDataString:model.image] placeholderImage:nil options:SDWebImageLowPriority];
    }else{
        
        _imgAvatarView.image = [UIImage imageNamed:@"test.png"];
        
    }
    
    _labUserName.frame=CGRectMake(63,20,_model.nameWidth,20);

 _contactAvatarView.frame=CGRectMake(CELL_SIDEMARGIN,CELL_SIDEMARGIN,HEAD_CONTACTAVATARVIEW_HEIGHT,HEAD_CONTACTAVATARVIEW_HEIGHT);
    
    _imgAvatarView.frame=CGRectMake(0,0,HEAD_IAMGE_HEIGHT,HEAD_IAMGE_HEIGHT);
    
   _btnUserScreenName.frame=CGRectMake(CGRectGetMaxX(_labUserName.frame)+Space,20,60,20);
    
    _labUserName.text = model.nickname;
    
    if (model.grade_name.length) {
        _btnUserScreenName.text = model.grade_name;
        _labUserName.textColor = MainColor;
    }else{
        _btnUserScreenName.hidden = YES;
         _labUserName.textColor = FontColor;
    }
    
    
    _btnUserScreenName.width = _btnUserScreenName.width+5;
    
    [_moreBtn setTitle:model.create_time forState:UIControlStateNormal];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self->_model.createTimeWidth+Space));
        make.height.equalTo(@(20));
        make.right.mas_equalTo(self.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self->_imgAvatarView.mas_centerY).offset(0);
    }];
    [_moreBtn setTitleColor:MJRefreshColor(102, 102, 102) forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
}

@end
