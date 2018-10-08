//
//  LocateView.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "LocateView.h"
#import "UIView+YYCore.h"

@interface LocateView()
{
    
    UILabel *_timeBtn;//时间
    UILabel *_distanceBtn;//距离
    UILabel *_seeBtn;//浏览
    
}
@end

@implementation LocateView


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
    
    _positionBtn = [[UIButton alloc]init];
//    _positionBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_positionBtn setImage:[UIImage imageNamed:@"定位带底"] forState:UIControlStateNormal];
    _positionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_positionBtn];
    
    _positionLab=[[UILabel alloc]init];
    _positionLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _positionLab.textColor = [UIColor darkGrayColor];
    _positionLab.font = [UIFont systemFontOfSize:12];
    [self addSubview:_positionLab];
    
    
    
    _timeBtn=[[UILabel alloc]init];
    _timeBtn.textColor = [UIColor lightGrayColor];
    _timeBtn.font = [UIFont systemFontOfSize:12];
    [self addSubview:_timeBtn];
    
    _distanceBtn=[[UILabel alloc]init];
    _distanceBtn.textColor = [UIColor lightGrayColor];
    _distanceBtn.font = [UIFont systemFontOfSize:12];
    [self addSubview:_distanceBtn];
    
    _seeBtn=[[UILabel alloc]init];
    _seeBtn.textColor = [UIColor lightGrayColor];
    _seeBtn.font = [UIFont systemFontOfSize:12];
    [self addSubview:_seeBtn];
    
    _delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _delBtn.hidden = YES;
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(delFriends:) forControlEvents:UIControlEventTouchUpInside];
    _delBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_delBtn];
    
}


- (void)delFriends:(UIButton*)sender{
    
    [self.delegate didSelectedDelBtn:sender];
    
}

#pragma mark － 配置位置
-(void)configurationLocation
{
    
    [_positionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.mas_left).offset(Space);
        make.top.mas_equalTo(self.mas_top).offset(15);
    }];
    
    [_positionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self->_homeCellViewModel.addressWidth);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self->_positionBtn.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(15);
    }];
    [_positionLab addRoundedCorners:UIRectCornerBottomRight | UIRectCornerTopRight withRadii:CGSizeMake(8.0, 8.0) viewRect:CGRectMake(0, 0, _homeCellViewModel.addressWidth, 20)];
    

    
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self->_homeCellViewModel.createTimeWidth);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.mas_left).offset(Space);
        make.top.mas_equalTo(self->_positionBtn.mas_bottom).offset(10);
    }];
    
    [_distanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self->_homeCellViewModel.distanceWidth);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self->_timeBtn.mas_right).offset(Space);
        make.top.mas_equalTo(self->_positionBtn.mas_bottom).offset(10);
    }];
    
    [_seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self->_homeCellViewModel.viewsWidth);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self->_distanceBtn.mas_right).offset(Space);
        make.top.mas_equalTo(self->_positionBtn.mas_bottom).offset(10);
    }];
    
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self->_seeBtn.mas_right).offset(Space);
        make.top.mas_equalTo(self->_positionBtn.mas_bottom).offset(10);
    }];
    
}

- (void)shopAction:(UIButton *)sender{
    
    [self.delegate didSelectedShopBtn:sender];
    
}

- (void)setHomeCellViewModel:(WeiContent *)homeCellViewModel{
    
    
    _homeCellViewModel = homeCellViewModel;
    
    [_positionBtn setImage:[UIImage imageNamed:@"定位带底"] forState:UIControlStateNormal];
    _positionLab.text = homeCellViewModel.shop_address;
    
    _seeBtn.text = homeCellViewModel.views;
    _distanceBtn.text = homeCellViewModel.distance;
    _timeBtn.text = homeCellViewModel.create_time;
    
    [self configurationLocation];
    
    //    进入商家界面
    UIButton *btn = [[UIButton alloc]init];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30+self->_homeCellViewModel.addressWidth);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.mas_left).offset(Space);
        make.top.mas_equalTo(self.mas_top).offset(15);
    }];
    btn.tag = self.positionBtn.tag;
    [btn addTarget:self action:@selector(shopAction:) forControlEvents:UIControlEventTouchUpInside];
    _delBtn.tag = self.positionBtn.tag;
}

@end
