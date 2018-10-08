//
//  GoodsTitleTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GoodsTitleTableViewCell.h"
#import "SDCycleScrollView.h"

@interface GoodsTitleTableViewCell ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *redpriceLab;
@property (nonatomic,strong) SDCycleScrollView *activityCycleView;

@end

@implementation GoodsTitleTableViewCell

+ (instancetype)goodsTitleTableViewCell{
    
    GoodsTitleTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsTitleTableViewCell" owner:nil options:nil][0];
    
    
    return cell;
}

+ (instancetype)goodsTitleTableViewCellKill{
    
    GoodsTitleTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsTitleTableViewCell" owner:nil options:nil][1];
    
    ZYLineProgressView *progressView = [[ZYLineProgressView alloc] init];
    
    //    progressView.score.text =
    [progressView updateConfig:^(ZYLineProgressViewConfig *config) {
        config.isShowDot = NO;
    }];
    
    [cell.contentView addSubview:progressView];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(cell.img.mas_right).offset(Space);
        make.top.mas_equalTo(cell.titleLab.mas_bottom).offset(Space);
        make.height.mas_equalTo(@(12));
        make.width.mas_equalTo(@(150));
        
    }];
    
    cell.progressView = progressView;
    
    return cell;
}

-(void)setGoodsDetail:(GoodsDetail *)goodsDetail{
    
    [_img sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goodsDetail.pic] placeholderImage:[UIImage imageNamed:@"test2"]];
    
    _titleLab.text = [NSString stringWithFormat:@"%@%@",goodsDetail.tag_name,goodsDetail.goods_name];
    
    _redpriceLab.text = [NSString stringWithFormat:@"¥%@",goodsDetail.dis_price];;
    
    if ([goodsDetail.is_activity integerValue] == 1) {
        _priceLab.text = goodsDetail.activity_price;
    }
    
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"门市价：%@",goodsDetail.org_price] attributes:attribtDic];
    
    // 赋值
    _priceLab.attributedText = attribtStr;
    _countLab.text = goodsDetail.sales;
    
    self.imagesURLAry = goodsDetail.son_pic;
}



#pragma mark - cycleView
- (SDCycleScrollView *)activityCycleView{
    
    if (!_activityCycleView) {
        
        _activityCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, kWidth*200/375) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        _activityCycleView.currentPageDotImage = [UIImage imageNamed:@"dot"];
        _activityCycleView.pageDotImage = [UIImage imageNamed:@"dot2"];
        
    }
    
    return _activityCycleView;
}

-(void)setImagesURLAry:(NSArray *)imagesURLAry{
    
    _imagesURLAry = imagesURLAry;
    [self.contentView addSubview:self.activityCycleView];
    
    if (_imagesURLAry.count == 0) {
        
        _activityCycleView.localizationImageNamesGroup = @[@"test2"];
        
    }else{
        
        _activityCycleView.imageURLStringsGroup = imagesURLAry;
        
        _activityCycleView.delegate = self;
        
    }
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
    
}


@end
