//
//  WeiContentTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiContentTableViewCell.h"
#define CELL_HEADVIEW_HEIGHT 55.0    //头部高度
#define CELL_BOTTOM_HEIGHT   54.0    //底部固定高度

#import "WeiContentImageView.h"
#import "WeiHeadView.h"
#import "LocateView.h"
#import "WeiBottomView.h"
#import "TYAttributedLabel.h"
#import "UIView+ShortCut.h"
#import "WeiContentImageView.h"

@interface WeiContentTableViewCell ()<TYAttributedLabelDelegate,WeiHeadViewDelegate,WeiBottomViewDelegate,LocateViewDelegate>

{
    
    WeiHeadView *_headView;//头部view
    
    TYAttributedLabel *_contentAttributedLabel;//自身内容
    
    WeiContentImageView *_contentImageView;//图片view
    
    LocateView *_locView;//底部定位view
    
    WeiBottomView *_bottomView;//底部view
    
    UILabel *_priceLab;//价钱view
}

@end

@implementation WeiContentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
      
    }
    return self;
}

#pragma 配置view
-(void)configurationContentView
{
    //    头部
    _headView=[[WeiHeadView alloc]init];
    _headView.backgroundColor=[UIColor whiteColor];
    _headView.delegate = self;
    [self.contentView addSubview:_headView];
    
    //    内容
    _contentAttributedLabel=[[TYAttributedLabel alloc]init];
    _contentAttributedLabel.delegate=self;
    
    _contentAttributedLabel.font = [UIFont systemFontOfSize:14];
    _contentAttributedLabel.highlightedLinkBackgroundColor=nil;
    _contentAttributedLabel.highlightedLinkColor=[UIColor redColor];
    [self.contentView addSubview:_contentAttributedLabel];
   
    _priceLab = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-Space-80, 45+15, 80, 20)];
    [self.contentView addSubview:_priceLab];
    _priceLab.textAlignment = NSTextAlignmentRight;
    _priceLab.font = [UIFont systemFontOfSize:14];
    _priceLab.textColor = MJRefreshColor(102, 102, 102);
    
    //    图片
    _contentImageView=[[WeiContentImageView alloc]init];
    [self.contentView addSubview:_contentImageView];
    
    //    底部
    _locView=[[LocateView alloc]init];
    _locView.delegate = self;
    [self.contentView addSubview:_locView];
    
    //    底部
    _bottomView=[[WeiBottomView alloc]init];
    _bottomView.delegate = self;
    [self.contentView addSubview:_bottomView];
}

#pragma mark － 配置位置
-(void)configurationLocation
{
    _headView.frame = CGRectMake(0,0,kWidth,55);
    
    if (_homeCellViewModel.price.length) {
        _contentAttributedLabel.frame = CGRectMake(CELL_SIDEMARGIN,CELL_HEADVIEW_HEIGHT+CELL_PADDING_6,kWidth-CELL_SIDEMARGIN*2 - 80,0);
    }else{
        _contentAttributedLabel.frame = CGRectMake(CELL_SIDEMARGIN,CELL_HEADVIEW_HEIGHT+CELL_PADDING_6,kWidth-CELL_SIDEMARGIN*2,0);
    }
    
    
    _contentImageView.frame = CGRectMake(0,0,kWidth,0);
    

}

-(void)setHomeCellViewModel:(WeiContent *)homeCellViewModel
{
    _homeCellViewModel = homeCellViewModel;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self configurationContentView];
    [self configurationLocation];
    _homeCellViewModel = homeCellViewModel;
    _headView.homeCellViewModel = homeCellViewModel;
    [_contentAttributedLabel  setTextContainer:_homeCellViewModel.textContainer];
    
    _contentAttributedLabel.height = homeCellViewModel.contentHeight;
    
    _contentImageView.backgroundColor=[UIColor whiteColor];
    _contentImageView.homeCellViewModel = homeCellViewModel;
//    _contentImageView.urlArray = homeCellViewModel.pic;
        _contentImageView.frame = CGRectMake(0,_contentAttributedLabel.bottom+CELL_PADDING_6, kWidth, homeCellViewModel.contengImageHeight);
    
   _locView.frame = CGRectMake(0,_contentImageView.bottom,kWidth, 80);
    if (_homeCellViewModel.shop_address.length) {
        _locView.positionBtn.hidden = NO;
        _locView.positionLab.hidden = NO;
        
    }else{
        _locView.positionBtn.hidden = YES;
        _locView.positionLab.hidden = YES;
        
    }
    
    if (_isDel) {
         _locView.delBtn.hidden = NO;
    }
    
    if (_homeCellViewModel.price.length) {
         _priceLab.text = _homeCellViewModel.price;
    }
   
    _locView.positionBtn.tag = self.tag;
    _bottomView.homeCellViewModel = homeCellViewModel;
    _locView.homeCellViewModel = homeCellViewModel;
    _bottomView.frame = CGRectMake(0, _locView.bottom, kWidth, CELL_BOTTOM_HEIGHT);
    
    _cellHeight = _homeCellViewModel.contentHeight + CELL_HEADVIEW_HEIGHT + _homeCellViewModel.contengImageHeight + 88 + CELL_BOTTOM_HEIGHT;
    
    
    _headView.moreBtn.tag = self.tag;
    _headView.contactAvatarView.tag = self.tag;
    _bottomView.btnPraise.tag = self.tag;
    _bottomView.btnComments.tag = self.tag;
    _bottomView.btnForwarding.tag = self.tag;
    _bottomView.realBtn.tag = self.tag;
    
//    判断视频
    if ([homeCellViewModel.type isEqualToString:@"2"]) {
        UIButton *play = [[UIButton alloc]init];
        [play setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
         [_contentImageView addSubview:play];
        
        if (homeCellViewModel.pic.count) {
            
            double height = [[homeCellViewModel.pic[0] objectForKey:@"height"] doubleValue];
            double width = [[homeCellViewModel.pic[0] objectForKey:@"width"] doubleValue];
            
            double maxWidth = kWidth -20;
            double maxHeight = 0.3*kHeight;
            double imgOneH = 0.0f;
            if (width) {
                
                if (width>height) {
                    //                    1.横图
                    imgOneH = maxWidth*height/width;
                    [play mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(kWidth/2+Space-30);
                        make.top.mas_equalTo(imgOneH/2-30);
                        make.width.height.equalTo(@(60));
                    }];
                    
                }else{
                    //                    1.竖图
                    imgOneH = maxHeight*(width/height);
                    [play mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo( imgOneH/2 -30+Space);
                        make.top.mas_equalTo(maxHeight/2-30);
                        make.width.height.equalTo(@(60));
                    }];
                }
                
            }

            play.tag = self.tag;
            [play addTarget:self action:@selector(didSelectedPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
            
        }
        
        
    
//    判断是否点赞
    if ([homeCellViewModel.is_praises boolValue]) {
        _bottomView.btnPraise.selected = YES;
    }else{
        _bottomView.btnPraise.selected = NO;
    }
    
//    判断是不是自己
    if ([PublicMethods isLogIn]) {
        
        NSString *uuid= [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"uuid"];
        
        if ([homeCellViewModel.uuid isEqualToString:uuid]) {
            _bottomView.realBtn.hidden = YES;
            _bottomView.btnComments.hidden = YES;
        }else{
            _bottomView.realBtn.hidden = NO;
            _bottomView.btnComments.hidden = NO;
        }
        
    }else{
        _bottomView.realBtn.hidden = NO;
        _bottomView.btnComments.hidden = NO;
    }
    
    
}

- (void)chooseMessege:(UIButton *)sender{
    [self.delegate chooseMessege:sender];
}

- (void)chooseComment:(UIButton *)sender{
    [self.delegate chooseComment:sender];
}

- (void)chooseZan:(UIButton *)sender{
    [self.delegate chooseZan:sender];
}

- (void)didSelectedMoreBtn:(UIButton *)sender{
    [self.delegate moreBtnAction:sender];
}

- (void)didSelectedPlayBtn:(UIButton *)sender{
    [self.delegate playBtnAction:sender];
}

- (void)didSelectedIconBtn:(UIButton *)sender{
    [self.delegate chooseIcon:sender];
}

- (void)didSelectedShopBtn:(UIButton *)sender{
    [self.delegate chooseShopAddress:sender];
}

- (void)didSelectedDelBtn:(UIButton *)sender{
    
    [self.delegate chooseDel:sender];
    
}
@end
