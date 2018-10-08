//
//  WeiAdvertTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiAdvertTableViewCell.h"
#import "WeiHeadView.h"
#import "WeiContentImageView.h"
#import "TYAttributedLabel.h"
#import "UIView+ShortCut.h"

#define CELL_HEADVIEW_HEIGHT 55.0    //头部高度
#define CELL_BOTTOM_HEIGHT   54.0    //底部固定高度

@interface WeiAdvertTableViewCell ()<TYAttributedLabelDelegate,WeiHeadViewDelegate>

{
    
    WeiHeadView *_headView;//头部view
    
    TYAttributedLabel *_contentAttributedLabel;//自身内容
    
    WeiContentImageView *_contentImageView;//图片view
    
    UILabel *_priceLab;//价钱view
    
    UIView *_bottomView;
}

@end


@implementation WeiAdvertTableViewCell

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
    
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:_bottomView];
}

#pragma mark － 配置位置
-(void)configurationLocation
{
    _headView.frame = CGRectMake(0,0,kWidth,55);
    
    _contentAttributedLabel.frame = CGRectMake(CELL_SIDEMARGIN,CELL_HEADVIEW_HEIGHT+CELL_PADDING_6,kWidth-CELL_SIDEMARGIN*2,0);
    _contentImageView.frame = CGRectMake(0,0,kWidth,0);
    
    
}

-(void)setHomeCellViewModel:(WeiContent *)homeCellViewModel
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self configurationContentView];
    [self configurationLocation];
    _homeCellViewModel = homeCellViewModel;
    _headView.homeCellViewModel = homeCellViewModel;
    [_contentAttributedLabel  setTextContainer:_homeCellViewModel.textContainer];
    
    _contentAttributedLabel.height = homeCellViewModel.contentHeight;
    
    _contentImageView.backgroundColor=[UIColor whiteColor];
    _contentImageView.homeCellViewModel = homeCellViewModel;
    _contentImageView.urlArray = homeCellViewModel.pic;
    _contentImageView.frame=CGRectMake(0,_contentAttributedLabel.bottom+CELL_PADDING_6, kWidth, homeCellViewModel.contengImageHeight);
    
   
    if (_homeCellViewModel.price.length) {
        _priceLab.text = _homeCellViewModel.price;
    }
   
    _cellHeight = _homeCellViewModel.contentHeight + CELL_HEADVIEW_HEIGHT + _homeCellViewModel.contengImageHeight + 40;
    
    _bottomView.frame = CGRectMake(0, _cellHeight-Space, kWidth, Space);
    
    _headView.moreBtn.tag = self.tag;
    _headView.contactAvatarView.tag = self.tag;
   
    
    //    判断视频
    if ([homeCellViewModel.type isEqualToString:@"2"]) {
        UIButton *play = [[UIButton alloc]init];
        [play setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_contentImageView addSubview:play];
        
        if (homeCellViewModel.pic.count) {
            
            double height = [[homeCellViewModel.pic[0] objectForKey:@"height"] doubleValue];
            double width = [[homeCellViewModel.pic[0] objectForKey:@"width"] doubleValue];
            
            if (height>width) {
                
                [play mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(45);
                    make.top.mas_equalTo(70);
                    make.width.height.equalTo(@(60));
                }];
                
            }else{
                
                [play mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(kWidth/2-Space*2);
                    make.top.mas_equalTo(65);
                    make.width.height.equalTo(@(60));
                }];
                
            }
            
            play.tag = self.tag;
            [play addTarget:self action:@selector(didSelectedPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
   
    
}

- (void)didSelectedIconBtn:(UIButton *)sender{
    [self.delegate chooseIconA:sender];
}

- (void)didSelectedMoreBtn:(UIButton *)sender{
    
     [self.delegate moreBtnActionA:sender];
    
}


@end
