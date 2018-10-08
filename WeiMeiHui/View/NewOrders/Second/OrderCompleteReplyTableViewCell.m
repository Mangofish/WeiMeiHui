//
//  OrderCompleteReplyTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "OrderCompleteReplyTableViewCell.h"
#import "GBTagListView.h"
#import "XHStarRateView.h"
#import "AuthorWorkCollectionViewCell.h"
#import "LHPhotoBrowser.h"

@interface OrderCompleteReplyTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic)  GBTagListView *bubbleView;
@property (strong, nonatomic) XHStarRateView *starRateView;

@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic)  NormalContentLabel *contentAttributedLabel;

@end

@implementation OrderCompleteReplyTableViewCell

+(instancetype)orderCompleteReplyTableViewCell{
    
    OrderCompleteReplyTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"OrderCompleteReplyTableViewCell" owner:self options:nil][0];
    
    return cell;
    
}


- (GBTagListView *)bubbleView{
    
    if (!_bubbleView) {
        
        _bubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 64, kWidth, 0)];
        /**允许点击 */
        _bubbleView.canTouch=NO;
        /**控制是否是单选模式 */
        _bubbleView.isSingleSelect=NO;
        _bubbleView.canTouchNum = 3;
        _bubbleView.signalTagColor=MJRefreshColor(242, 242, 242);
        
    }
    
    return _bubbleView;
    
}


- (void)setOrder:(OrderComment *)order{
    
    _finaStrTag = order.eva_tag;
    _order = order;
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *obj in _finaStrTag) {
        [temp addObject:obj];
    }
    
    _finaStrTag = temp;
    [self.bubbleView setTagWithTagArray:_finaStrTag];
    [self.contentView addSubview:self.bubbleView];
    
    self.cellHeight =  CGRectGetMaxY(self.bubbleView.frame) + 92;
    
    self.starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(kWidth/3, CGRectGetMaxY(self.bubbleView.frame) +20, kWidth/3, 20)];
    self.starRateView.isAnimation = YES;
    self.starRateView.rateStyle = HalfStar;
    self.starRateView.currentScore = [order.eva_starts doubleValue];
    [self.contentView addSubview:self.starRateView];
    
    _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,CGRectGetMaxY(self.starRateView.frame)+Space,kWidth-CELL_SIDEMARGIN*2,_order.contentHeight)];
    [self.contentView addSubview:_contentAttributedLabel];
    
    CGFloat itemW = (kWidth-Space*2-30)/4;
    
    if (_order.eva_pic.count) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.contentAttributedLabel.frame)+Space, kWidth-Space*2, itemW) collectionViewLayout:layout];
        [self.contentView addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        
       
    }
    //    _contentAttributedLabel.textContainer = _order.authorTextContainer;
    

    _contentAttributedLabel.text = _order.eva_content;
    
    if (order.eva_pic.count) {
         _cellHeight = CGRectGetMaxY(_collectionView.frame) + Space;
    }else{
         _cellHeight = CGRectGetMaxY(_contentAttributedLabel.frame) + Space;
    }
   
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    AuthorWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.workImg sd_setImageWithURL:[NSURL URLWithString:_order.eva_pic[indexPath.item]]];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _order.eva_pic.count;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AuthorWorkCollectionViewCell *cell = (AuthorWorkCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];
    
    bc.imgsArray = @[cell.workImg];
    bc.imgUrlsArray = @[ _order.eva_pic[indexPath.item] ];
    bc.tapImgIndex = 0;
    bc.hideStatusBar = NO;
    [bc show];
    
}


@end
