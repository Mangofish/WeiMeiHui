//
//  MyReplyTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MyReplyTableViewCell.h"
#import "NormalContentLabel.h"
#import "AuthorWorkCollectionViewCell.h"
#import "LHPhotoBrowser.h"

@interface MyReplyTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic)  UICollectionView *collectionView;
@property (strong, nonatomic)  NormalContentLabel *contentAttributedLabel;

@end


@implementation MyReplyTableViewCell

+(instancetype)myReplyTableViewCell{
    
    MyReplyTableViewCell *cell = [[NSBundle mainBundle ] loadNibNamed:@"MyReplyTableViewCell" owner:self options:nil][0];
    
    return cell;
}

- (void)configLocation{
    
    CGFloat itemW = (kWidth-Space*2-30)/4;
    
    if (_order.pics_author.count) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 47, kWidth-Space*2, itemW) collectionViewLayout:layout];
        [self.contentView addSubview:_collectionView];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;

        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,CGRectGetMaxY(_collectionView.frame)+Space,kWidth-CELL_SIDEMARGIN*2,_order.authorContentHeight)];
        [self.contentView addSubview:_contentAttributedLabel];
    }else{
        
        _contentAttributedLabel = [[NormalContentLabel alloc]initWithFrame:CGRectMake(Space,47,kWidth-CELL_SIDEMARGIN*2,_order.authorContentHeight)];
        [self.contentView addSubview:_contentAttributedLabel];
    }
//    _contentAttributedLabel.textContainer = _order.authorTextContainer;
    
    
    
    _contentAttributedLabel.text = _order.author_content;
    _cellHeight = CGRectGetMaxY(_contentAttributedLabel.frame) + Space;
}

- (void)setOrder:(AuthorOrdersModel *)order{
    _order = order;
    [self configLocation];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    AuthorWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.workImg sd_setImageWithURL:[NSURL URLWithString:_order.pics_author[indexPath.item]]];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _order.pics_author.count;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AuthorWorkCollectionViewCell *cell = (AuthorWorkCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];
    
    bc.imgsArray = @[cell.workImg];
    bc.imgUrlsArray = @[ _order.pics_author[indexPath.item] ];
    bc.tapImgIndex = 0;
    bc.hideStatusBar = NO;
    [bc show];
    
}

@end
