//
//  CommentTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "TYAttributedLabel.h"
#import "UIButton+WebCache.h"


@interface CommentTableViewCell ()<TYAttributedLabelDelegate>
{
//    WeiHeadView *_headView;//头部view
}
@property (strong, nonatomic)  UIView *line;

@property (strong, nonatomic)  TYAttributedLabel *contentAttributedLabel;

@end


@implementation CommentTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self configurationContentView];
//        [self configurationLocation];
    }
    return self;
}

#pragma 配置view
-(void)configurationContentView
{
    //    头部
    _headView=[[WeiHeadView alloc]init];
    _headView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_headView];
    
    //    内容
    _contentAttributedLabel=[[TYAttributedLabel alloc]init];
    _contentAttributedLabel.delegate=self;
    _contentAttributedLabel.font = [UIFont systemFontOfSize:14];
    _contentAttributedLabel.highlightedLinkBackgroundColor=nil;
    [self.contentView addSubview:_contentAttributedLabel];
    
    
    //    底部
    _line=[[UIView alloc]init];
    [self.contentView addSubview:_line];
    _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
   
}

- (void)configurationLocation{
    
    _headView.frame = CGRectMake(0,0,kWidth,55);
    _contentAttributedLabel.frame = CGRectMake(CELL_SIDEMARGIN,55+CELL_PADDING_6,kWidth-CELL_SIDEMARGIN*2 ,_model.contentHeight);
    _line.frame = CGRectMake(0,CGRectGetMaxY(_contentAttributedLabel.frame)+Space-1,kWidth ,1);
    
    _cellHeight = 55+CELL_PADDING_6 + _model.contentHeight +Space;
}

- (void)setModel:(CommentList *)model{
    _model = model;
    _headView.contactAvatarView.tag = self.tag;
    _headView.model = model;
    [_contentAttributedLabel  setTextContainer:model.textContainer];
    
    
    [self configurationLocation];
}

- (void)setModelHome:(WeiContent *)modelHome{
    
//    _headView.homeCellViewModel = modelHome;
    
    
}

@end
