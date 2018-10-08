//
//  CommentOrderTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CommentOrderTableViewCell.h"
#import "TYAttributedLabel.h"
#import "XHStarRateView.h"
#import "TZTestCell.h"
#import "TZCollectionViewFlowLayout.h"
#import "LHPhotoBrowser.h"

@interface CommentOrderTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
     //自身内容
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic)  TYAttributedLabel *contentAttributedLabel;
@property (strong, nonatomic)   XHStarRateView *starRateView;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) TZCollectionViewFlowLayout *layout;

@end

@implementation CommentOrderTableViewCell

+(instancetype)commentOrderTableViewCell{
    
    CommentOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"CommentOrderTableViewCell" owner:self options:nil][0];
    
    cell.contentAttributedLabel = [[TYAttributedLabel alloc]init];
    [cell.contentView addSubview:cell.contentAttributedLabel];
    cell.iconImg.layer.cornerRadius = 20;
    cell.iconImg.layer.masksToBounds = YES;
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(60, 10+25, 90, 14)];
    [cell.contentView addSubview:starRateView];
    cell.starRateView = starRateView;
    cell.starRateView.userInteractionEnabled = NO;
    return cell;
    
}

+(instancetype)commentOrderTableViewCellWithPic{
    
    CommentOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"CommentOrderTableViewCell" owner:self options:nil][1];
    
    cell.contentAttributedLabel = [[TYAttributedLabel alloc]init];
    [cell.contentView addSubview:cell.contentAttributedLabel];
    cell.iconImg.layer.cornerRadius = 20;
    cell.iconImg.layer.masksToBounds = YES;
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(60, 10+25, 90, 14)];
    [cell.contentView addSubview:starRateView];
    cell.starRateView = starRateView;
    cell.starRateView.userInteractionEnabled = NO;
    return cell;
    
}

- (void)setComment:(OrderComment *)comment{
    
    _comment = comment;

    self.starRateView.currentScore = [comment.eva_starts doubleValue];
    
    if (comment.eva_image.length) {
        [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:comment.eva_image]];
    }
    
    _name.text = comment.eva_nickname;
    _contentAttributedLabel.textContainer = comment.textContainer;
    _contentAttributedLabel.frame = CGRectMake(Space, 60, kWidth-Space*2, comment.contentHeight);
    _cellHeight = CGRectGetMaxY(_contentAttributedLabel.frame)+10;
    _time.text = comment.eva_time;
    
    if (comment.eva_pic.count) {
        [self.contentView addSubview:self.collectionView];
         _cellHeight = CGRectGetMaxY(self.collectionView.frame)+10;
    }
}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        _layout = [[TZCollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentAttributedLabel.frame)+10, kWidth,115) collectionViewLayout:_layout];
        
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(5, 10,5, 10);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
        
    }
    
    return _collectionView;
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
    return self.comment.eva_pic.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    [cell.imageView sd_setImageWithURL:self.comment.eva_pic[indexPath.row] placeholderImage:[UIImage imageNamed:@"test2"]];
    cell.deleteBtn.hidden = YES;
    cell.gifLable.hidden = YES;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TZTestCell *cell = (TZTestCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    LHPhotoBrowser *bc = [[LHPhotoBrowser alloc] init];
    
    bc.imgsArray = @[cell.imageView];
    bc.imgUrlsArray = @[ self.comment.eva_pic[indexPath.row] ];
    bc.tapImgIndex = 0;
    bc.hideStatusBar = NO;
    [bc show];
    
}

@end
