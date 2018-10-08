//
//  AuthorDetailHead.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorDetailHead.h"
#import "ZYLineProgressView.h"
#import "GBTagListView.h"
#import "XHStarRateView.h"

@interface AuthorDetailHead ()

@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *cent;
@property (weak, nonatomic) IBOutlet UILabel *betterLab;
@property (weak, nonatomic) IBOutlet UIView *tagBg;
@property (nonatomic, weak) ZYLineProgressView *progressView;
@property (strong, nonatomic) GBTagListView *bubbleView;

@property (strong, nonatomic)   XHStarRateView *starRateView;

@end


@implementation AuthorDetailHead

+(instancetype)authorDetailHead{
    
    AuthorDetailHead *instance = [[NSBundle mainBundle] loadNibNamed:@"AuthorDetailHead" owner:self options:nil][0];
    
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(65, 70, 100, 12)];
    [instance addSubview:starRateView];
    instance.starRateView = starRateView;
    instance.starRateView.userInteractionEnabled = NO;
    instance.starRateView.rateStyle = HalfStar;
    return instance;
    
}

+ (instancetype)authorDetailHeadMine{
    
    AuthorDetailHead *instance = [[NSBundle mainBundle] loadNibNamed:@"AuthorDetailHead" owner:self options:nil][1];
    
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(70, 50, 90, 14)];
    [instance addSubview:starRateView];
    instance.starRateView = starRateView;
    instance.starRateView.rateStyle = HalfStar;
//    instance.starRateView.
//    ZYLineProgressView *progressView = [[ZYLineProgressView alloc] init];
//    [progressView updateConfig:^(ZYLineProgressViewConfig *config) {
//        config.isShowDot = NO;
//    }];
//    [instance addSubview:progressView];
//
//    progressView.progress = 0.9;
//    instance.progressView = progressView;
//    progressView.frame = CGRectMake(Space+22, 75, 100, 12);
    return instance;
    
}


- (GBTagListView *)bubbleView{
    
    if (!_bubbleView) {
        
        _bubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0)];
        /**允许点击 */
        _bubbleView.canTouch=NO;
        /**控制是否是单选模式 */
        _bubbleView.isSingleSelect=YES;
        _bubbleView.signalTagColor=MJRefreshColor(242, 242, 242);
        _bubbleView.signalTagLayerColor = MJRefreshColor(242, 242, 242);
    }
    
    return _bubbleView;
    
}


- (void)setTagAry:(NSArray *)tagAry{
    
    [self.bubbleView removeFromSuperview];
    self.bubbleView = nil;
    
//    if (!_bubbleView) {
    
        [self.bubbleView setTagWithTagArray:tagAry];
        [self.tagBg addSubview:self.bubbleView];
  
        self.tagBg.frame = CGRectMake(0, 95, kWidth, self.bubbleView.frame.size.height);
        
//    }
    
    _cellHeight = CGRectGetMaxY(self.tagBg.frame);
}

- (void)setModel:(ShopModel *)model{
    
    _model =model;
    
//    self.tagAry = model.
    self.starRateView.currentScore = [model.score doubleValue];
    self.starRateView.userInteractionEnabled = NO;
    _scoreLab.text = [NSString stringWithFormat:@"%@分",model.score];
    _cent.text = model.good_percent;
    _betterLab.text = model.better_percent;
    _countLab.text = [NSString stringWithFormat:@"用户评价（%@）",model.evaluate_count];;
}

- (void)setModelGoods:(ShopModel *)modelGoods{
    
    _modelGoods =modelGoods;
    
    //    self.tagAry = model.
    self.starRateView.currentScore = [modelGoods.sum_score doubleValue];
    self.starRateView.userInteractionEnabled = NO;
    _scoreLab.text = [NSString stringWithFormat:@"%@分",modelGoods.sum_score];
    _cent.text = modelGoods.good_percent;
    _betterLab.text = modelGoods.better_percent;
    _countLab.text = [NSString stringWithFormat:@"用户评价（%@）",modelGoods.evaluate_count];;
}

@end
