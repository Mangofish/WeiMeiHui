//
//  FamousShopTitleTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "FamousShopTitleTableViewCell.h"
#import "XHStarRateView.h"
#import "SDCycleScrollView.h"

@interface FamousShopTitleTableViewCell ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UILabel *shopsAquaLab;
@property (weak, nonatomic) IBOutlet UILabel *disLab;

@property (strong, nonatomic)   XHStarRateView *starRateView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UIView *lightBackView;
@property (nonatomic,strong) SDCycleScrollView *activityCycleView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;

@property (weak, nonatomic) IBOutlet UIImageView *img;




@end

@implementation FamousShopTitleTableViewCell

+ (instancetype)famousShopTitleTableViewCell{
    
    FamousShopTitleTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousShopTitleTableViewCell" owner:nil options:nil][0];
    
    CGRect rect = CGRectMake(Space, 60, 85, 12);
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:rect];
    [instance.lightBackView addSubview:starRateView];
    
    [starRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(85));
        make.height.equalTo(@(12));
        make.left.mas_equalTo(instance.lightBackView.mas_left).offset(Space);
        make.bottom.mas_equalTo(instance.lightBackView.mas_bottom).offset(-11);
    }];
    
    instance.starRateView = starRateView;
    instance.starRateView.rateStyle = HalfStar;
    
    return instance;
}

+ (instancetype)famousShopTitleTableViewCellSingle{
    
    FamousShopTitleTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousShopTitleTableViewCell" owner:nil options:nil][1];
    
    CGRect rect = CGRectMake(Space, 60, 85, 12);
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:rect];
    [instance.lightBackView addSubview:starRateView];
    
    [starRateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(85));
        make.height.equalTo(@(14));
        make.left.mas_equalTo(instance.img.mas_right).offset(Space);
        make.bottom.mas_equalTo(instance.lightBackView.mas_bottom).offset(-10);
    }];
    
    instance.starRateView = starRateView;
    instance.starRateView.rateStyle = HalfStar;
    
    return instance;
}

- (void)setAuthor:(ShopAndAuthor *)author{
    
    _author = author;
    
    _nameLab.text = author.shop_name;
    _addressLab.text = author.address;

    _shopsAquaLab.text = author.dump_name;
    _disLab.text = author.distance;
    _scoreLab.text = author.average_score;
    _orderLab.text = author.order_num;
    
    self.imagesURLAry = author.son_pic;
    
    self.starRateView.currentScore = [author.score doubleValue];
    self.starRateView.userInteractionEnabled = NO;
    
}

- (void)setAuthorSingle:(ShopAndAuthor *)authorSingle{
    
    
    
    _nameLab.text = authorSingle.shop_name;
    _addressLab.text = authorSingle.address;
    
    _shopsAquaLab.text = authorSingle.fans_count;
    _disLab.text = authorSingle.dump_name;
    _distanceLab.text = authorSingle.distance;
    _scoreLab.text = authorSingle.average_score;
    _orderLab.text = authorSingle.order_num;
    
    [_img sd_setImageWithURL:[NSURL urlWithNoBlankDataString:authorSingle.pic] placeholderImage:[UIImage imageNamed:@"test2"]];
    
    self.starRateView.currentScore = [authorSingle.score_order doubleValue];
    self.starRateView.userInteractionEnabled = NO;
    
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

- (IBAction)location:(UIButton *)sender {
    
    [self.delegate locationAction];
}
@end
