//
//  FamousShopTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "FamousShopTableViewCell.h"
#import "ShopAuthorsCollectionViewCell.h"
#import "XHStarRateView.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
@interface FamousShopTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    NSInteger _second;
    // 上下滚动的跑马灯
    JhtVerticalMarquee *_verticalMarquee;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UILabel *shopsAquaLab;
@property (weak, nonatomic) IBOutlet UILabel *disLab;
@property (weak, nonatomic) IBOutlet UILabel *redLab;

@property (strong, nonatomic)   XHStarRateView *starRateView;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UIView *lightBackView;
//@property (strong, nonatomic)  NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end

@implementation FamousShopTableViewCell

+ (instancetype)famousShopTableViewCell{
    
    FamousShopTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousShopTableViewCell" owner:nil options:nil][0];
    
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

+ (instancetype)famousShopTableViewCellExclusive{
    
    FamousShopTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousShopTableViewCell" owner:nil options:nil][2];
    
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


+ (instancetype)famousShopTableViewCellMain{
    
    FamousShopTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousShopTableViewCell" owner:nil options:nil][1];
    
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


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    ShopAuthorsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.author.author_data[indexPath.item];
    
    [cell.iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:dic[@"image"]] placeholderImage:[UIImage imageNamed:@"test"]];
    cell.nameLab.text = dic[@"nickname"];
    cell.priceLab.text = dic[@"price"];
    CGFloat itemW = (kWidth-90)/4;
    cell.iconImg.layer.cornerRadius = (itemW-12)/2;
    cell.iconImg.layer.masksToBounds = YES;
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.author.author_data.count;
    
}

- (void)setAuthor:(ShopAndAuthor *)author{
    
    _author = author;
    
    [_backImg sd_setImageWithURL:[NSURL URLWithString:author.pic] placeholderImage:[UIImage imageNamed:@"test2"]];
    _nameLab.text = author.shop_name;
    _addressLab.text = author.address;
    _fansLab.text = author.fans_count;
    _shopsAquaLab.text = author.dump_name;
    _disLab.text = author.distance;
    _scoreLab.text = author.average_score;
    _orderLab.text = author.order_num;
    
    self.starRateView.currentScore = [author.score_order doubleValue];
    self.starRateView.userInteractionEnabled = NO;
    
    CGFloat itemW = (kWidth-90)/4;
    CGFloat itemH = (itemW-6)+10+30;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.sectionInset = UIEdgeInsetsMake(Space, Space, 0, Space*2);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(Space, 40*(kWidth-20)/71, kWidth-20, itemH+10) collectionViewLayout:layout];
    [self.contentView addSubview:_collectionView];

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ShopAuthorsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
}

- (void)setAuthorMain:(ShopAndAuthor *)authorMain{
    
    _authorMain = authorMain;
    
    [_backImg sd_setImageWithURL:[NSURL URLWithString:authorMain.pic] placeholderImage:[UIImage imageNamed:@"test2"]];
    _nameLab.text = authorMain.shop_name;
    _addressLab.text = authorMain.address;
    _fansLab.text = authorMain.fans_count;
    _shopsAquaLab.text = authorMain.dump_name;
    _disLab.text = authorMain.distance;
    _scoreLab.text = authorMain.average_score;
    _orderLab.text = authorMain.order_num;
    
    self.starRateView.currentScore = [authorMain.score_order doubleValue];
    self.starRateView.userInteractionEnabled = NO;
    
    _whiteView.hidden = NO;
    _redLab.hidden = YES;
    
    if (authorMain.activity_data.count >1 ) {
        
        // 开启跑马灯
        _verticalMarquee = [[JhtVerticalMarquee alloc]  initWithFrame:CGRectMake(Space, 0, kWidth/2 , 44)];
        _verticalMarquee.verticalTextFont = [UIFont systemFontOfSize:12];
        _verticalMarquee.verticalTextColor = MainColor;
        [self.whiteView addSubview:_verticalMarquee];
        [_verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
         _verticalMarquee.sourceArray = authorMain.activity_data;
        
    }else if (authorMain.activity_data.count == 1){
        
        _redLab.hidden = NO;
        _redLab.text = authorMain.activity_data[0];
        
    }else{
        
        _whiteView.hidden = YES;
        
    }
    
   
   
}

- (void)setAuthorExclusive:(ShopAndAuthor *)authorExclusive{
    
    _authorMain = authorExclusive;
    
    [_backImg sd_setImageWithURL:[NSURL URLWithString:authorExclusive.pic] placeholderImage:[UIImage imageNamed:@"test2"]];
    _nameLab.text = authorExclusive.shop_name;
    _addressLab.text = authorExclusive.address;
    _fansLab.text = authorExclusive.fans_count;
    _shopsAquaLab.text = authorExclusive.dump_name;
    _disLab.text = authorExclusive.distance;
    _scoreLab.text = authorExclusive.average_score;
    _orderLab.text = authorExclusive.order_num;
    
    self.starRateView.currentScore = [authorExclusive.score_order doubleValue];
    self.starRateView.userInteractionEnabled = NO;
    
    
}

@end
