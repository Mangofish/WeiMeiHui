//
//  WeiBottomView.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiBottomView.h"
#import "UIView+ShortCut.h"
@interface  WeiBottomView()
{
    UIView *_backView;
    
    UIView *_backView2;
    
    UIImageView *_topBG;//画一条线.....

//    UIButton *_btnForwarding;//转发
//    
//    UIButton *_btnComments;//私信
//   
//    UIButton *_btnPraise;//赞
}
@end

@implementation WeiBottomView

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        
        [self configurationContentView];
        
    }
    return self;
}


#pragma 配置view
-(void)configurationContentView
{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 54)];
    _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_backView];
    
    _backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    _backView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView2];
    
    _topBG=[[UIImageView alloc]init];
    _topBG.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_topBG];
    
    //赞
    _btnPraise=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnPraise.backgroundColor=[UIColor clearColor];
    
    [_btnPraise setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _btnPraise.titleLabel.font=[UIFont systemFontOfSize:12.0];
    _btnPraise.imageEdgeInsets=UIEdgeInsetsMake(0,0,0,10);
    _btnPraise.titleEdgeInsets=UIEdgeInsetsMake(0,10,0,0);
    [_btnPraise addTarget:self action:@selector(chooseZanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnPraise];
    [_btnPraise setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    [_btnPraise setImage:[UIImage imageNamed:@"点赞2"] forState:UIControlStateSelected];
    
    //转发
    _btnForwarding=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnForwarding.backgroundColor=[UIColor clearColor];
    
    [_btnForwarding setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _btnForwarding.titleLabel.font=[UIFont systemFontOfSize:12.0];
    _btnForwarding.imageEdgeInsets=UIEdgeInsetsMake(0,0,0,10);
    _btnForwarding.titleEdgeInsets=UIEdgeInsetsMake(0,10,0,0);
    [_btnForwarding addTarget:self action:@selector(chooseCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnForwarding];
    
    
    //评论
    _btnComments=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnComments.backgroundColor=[UIColor clearColor];
    
    [_btnComments setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _btnComments.titleLabel.font=[UIFont systemFontOfSize:12.0];
    _btnComments.imageEdgeInsets=UIEdgeInsetsMake(-1,0,0,10);
    _btnComments.titleEdgeInsets=UIEdgeInsetsMake(0,10,0,0);
//    [_btnComments addTarget:self action:@selector(chooseMessegeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnComments];
    
    _realBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _realBtn.backgroundColor=[UIColor clearColor];

    [_realBtn addTarget:self action:@selector(chooseMessegeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_realBtn];
}

#pragma mark － 配置位置
-(void)configurationLocation
{
    _topBG.frame = CGRectMake(Space,0,kWidth-Space*2,1.0f);
    
    [_btnPraise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self->_homeCellViewModel.praiseWidth+5);
//        make.height.mas_equalTo(12);
        make.left.mas_equalTo(self.mas_left).offset(Space);
        make.centerY.mas_equalTo(self->_backView2.mas_centerY).offset(0);
    }];
    
    
    [_btnForwarding mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(12);
        make.width.mas_equalTo(self->_homeCellViewModel.commentWidth);
        make.left.mas_equalTo(self->_btnPraise.mas_right).offset(Space*4);
        make.centerY.mas_equalTo(self->_backView2.mas_centerY).offset(0);
    }];
    
    [_realBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(12);
        make.width.mas_equalTo(200);
        make.right.mas_equalTo(self.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self->_backView2.mas_centerY).offset(0);
    }];
    
    [_btnComments mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(12);
        //        make.width.mas_equalTo(200);
        make.right.mas_equalTo(self.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self->_backView2.mas_centerY).offset(0);
    }];
    
    [_btnForwarding layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    [_btnComments layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [_btnPraise layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:6];
}


#pragma 设置值
-(void)setHomeCellViewModel:(WeiContent *)homeCellViewModel
{
    _homeCellViewModel=homeCellViewModel;
   
    
    //底部
    if ([homeCellViewModel.is_praises integerValue] == 0) {
        _btnPraise.selected = NO;
    }else{
       _btnPraise.selected = YES;
    }
    
    [_btnPraise setTitle:homeCellViewModel.praises forState:UIControlStateNormal];
    
    [_btnForwarding setTitle:homeCellViewModel.comments forState:UIControlStateNormal];
    [_btnForwarding setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    
    
//    [_btnComments setTitle: @"私信" forState:UIControlStateNormal];
    [_btnComments setImage:[UIImage imageNamed:@"私信首页"] forState:UIControlStateNormal];
    
    
    [self configurationLocation];
}

- (void)chooseZanAction:(UIButton *)sender{
    
    
//    if ([PublicMethods isLogIn]) {
//        
//        sender.selected = !sender.selected;
//        [self layoutIfNeeded];
//        NSUInteger count = [_btnPraise.currentTitle integerValue];
//        
//        if (sender.selected ) {
//            count += 1;
//            [_btnPraise setTitle:[NSString stringWithFormat:@"%lu",count] forState:UIControlStateNormal];
//        }else{
//            count -= 1;
//            [_btnPraise setTitle:[NSString stringWithFormat:@"%lu",count] forState:UIControlStateNormal];
//        }
//        
//    }
    
    [self.delegate chooseZan:sender];
    
    
}
- (void)chooseCommentAction:(UIButton *)sender{
    [self.delegate chooseComment:sender];
}
- (void)chooseMessegeAction:(UIButton *)sender{
    [self.delegate chooseMessege:sender];
}

@end
