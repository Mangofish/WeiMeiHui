//
//  AlreadyOrderTableViewCell.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AlreadyOrderTableViewCell.h"
#import "GBTagListView.h"
#import "UIButton+WebCache.h"
#import "ZYLineProgressView.h"

#import "AuthorWorkCollectionViewCell.h"
#import "TYAttributedLabel.h"
#import "LHPhotoBrowser.h"

@interface AlreadyOrderTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource> {
    
    TYAttributedLabel *_contentAttributedLabel;//自身内容
    
}
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UIButton *nickBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (strong, nonatomic)  GBTagListView *bubbleView;
@property (strong, nonatomic)  ZYLineProgressView *progressView;

@property (strong, nonatomic)  UICollectionView *imgCollectionView;

@end
@implementation AlreadyOrderTableViewCell

+(instancetype)alreadyOrderTableViewCell{
    
    AlreadyOrderTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"AlreadyOrderTableViewCell" owner:nil options:nil][0];
    
    
    ZYLineProgressView *progressView = [[ZYLineProgressView alloc] init];
    [progressView updateConfig:^(ZYLineProgressViewConfig *config) {
        config.isShowDot = NO;
    }];
    [instance addSubview:progressView];
    
    progressView.progress = 0.01;
    instance.progressView = progressView;
    
    return instance;
}

- (GBTagListView *)bubbleView{
    
    if (!_bubbleView) {
        
        _bubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(5, 98, kWidth-Space, 0)];
        /**允许点击 */
        _bubbleView.canTouch=NO;
        /**控制是否是单选模式 */
        _bubbleView.isSingleSelect=YES;
        _bubbleView.canTouchNum = 0;
        _bubbleView.signalTagColor=MJRefreshColor(242, 242, 242);
//        __block NSArray *tag = _tagAry;
        _bubbleView.didselectItemBlock = ^(NSArray *arr) {
            
        };
        
    }
    
    return _bubbleView;
    
}


-(void)setTagAry:(NSArray *)tagAry{
    _tagAry = tagAry;
    [self.contentView addSubview:self.bubbleView];
    [self.bubbleView setTagWithTagArray:tagAry];
//    self.bubbleView.frame = CGRectMake(5, 100, kWidth-10, self.bubbleView.fz);
//    _cellHeight  = CGRectGetMaxY(self.bubbleView.frame) + 67;
}

- (void)setOrder:(MainOrderStatusAlready *)order{
    
    _order = order;
    
    NSMutableArray *tagtemp = [NSMutableArray array];
    
    for (NSDictionary *obj in order.service) {
        NSString *str = [NSString stringWithFormat:@"%@  (%@)",obj[@"name"],obj[@"num"]];
        [tagtemp addObject:str];
    }
    self.tagAry = tagtemp;
    
    [_iconBtn sd_setImageWithURL:[NSURL urlWithNoBlankDataString:order.image] forState:UIControlStateNormal];
    _nameLab.text = order.nickname;
    _orderCount.text = order.order;
    _shopName.text = order.shop_name;
    _priceLab.text = order.price;
    
    _progressView.progress = [order.score doubleValue]/100;
    _progressView.progressText = order.score;
    _progressView.frame = CGRectMake(order.countWidth+68, CGRectGetMaxY(_nameLab.frame)+6, 100, 12);
    
    _vipBtn.hidden = NO;
    _nickBtn.hidden = NO;
    
    
    _payBtn.tag = self.tag;
    _iconBtn.tag = self.tag;
    
    if (order.order_pic.count) {
    
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        CGFloat itemW = (kWidth - Space*4)/4;
        
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.minimumInteritemSpacing = 5;
        
        
        self.imgCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(self.bubbleView.frame)+Space, kWidth-Space*2, itemW) collectionViewLayout:layout];
        
        
        [self.contentView addSubview:self.imgCollectionView];
        self.imgCollectionView.delegate = self;
        self.imgCollectionView.dataSource = self;
        self.imgCollectionView.backgroundColor = [UIColor whiteColor];
        [self.imgCollectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.imgCollectionView.scrollEnabled = NO;
        
    }
    
    if (order.order_pic.count) {
         _contentAttributedLabel = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(self.imgCollectionView.frame)+Space, kWidth-Space*2,order.textContainer.textHeight)];
    }else{
         _contentAttributedLabel = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(Space, CGRectGetMaxY(self.bubbleView.frame)+Space, kWidth-Space*2,order.textContainer.textHeight)];
    }
    
   
    [self.contentView addSubview:_contentAttributedLabel];
    _contentAttributedLabel.textContainer = order.textContainer;

    
    _cellHeight = CGRectGetMaxY(_contentAttributedLabel.frame)+Space*2+44;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AuthorWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.workImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:self.order.order_pic[indexPath.item]]];
    
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _order.order_pic.count;
    
//    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AuthorWorkCollectionViewCell *cell = (AuthorWorkCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];
    
    bc.imgsArray = @[cell.workImg];
    bc.imgUrlsArray = @[ _order.order_pic[indexPath.item] ];
    bc.tapImgIndex = 0;
    bc.hideStatusBar = NO;
    [bc show];
    
}

- (IBAction)payAction:(UIButton *)sender {
    
    [self.delegate didClickPayOrder:sender.tag];
    
}

- (IBAction)messageAction:(UIButton *)sender {
    
    [self.delegate didClickMessageBtn:sender.tag];
}

- (IBAction)iconAction:(UIButton *)sender {
    [self.delegate didClickIcon:sender.tag];
}
@end
