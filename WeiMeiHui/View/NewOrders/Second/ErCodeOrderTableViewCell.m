//
//  ErCodeOrderTableViewCell.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ErCodeOrderTableViewCell.h"
#import "JoinUserIconCollectionViewCell.h"
@implementation ErCodeOrderTableViewCell

+(instancetype)erCodeOrderTableViewCell{
    
    ErCodeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ErCodeOrderTableViewCell" owner:self options:nil][0];
    
    return cell;
    
}

+(instancetype)erCodeOrderTableViewCellEasy{
    
    ErCodeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ErCodeOrderTableViewCell" owner:self options:nil][1];
    
    return cell;
    
}

+(instancetype)erCodeOrderTableViewCellTime{
    
    ErCodeOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ErCodeOrderTableViewCell" owner:self options:nil][2];
    
    return cell;
    
}

- (void)setGoodsDetailEasy:(ThreeOrder *)goodsDetailEasy{
    
    [_imger sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goodsDetailEasy.qrCode] placeholderImage:[UIImage imageNamed:@"test2"]];
    _orderNumer.text = goodsDetailEasy.order_number;
    _dateLab.text = goodsDetailEasy.expire_time;
}




- (void)setGoodsDetail:(GoodsDetail *)goodsDetail{
    
    _goodsDetail = goodsDetail;
    _time.text =  [NSString stringWithFormat:@"拼团成功时间：%@",goodsDetail.suc_time];
    [_img sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goodsDetail.qrCode] placeholderImage:[UIImage imageNamed:@"test2"]];
    _orderNum.text = goodsDetail.order_number;
    NSUInteger count = [goodsDetail.group_num integerValue];
    
    CGFloat itemW = 40;
    CGFloat space = 20;
    CGFloat width = itemW*count +space *(count-1);
    CGFloat x = (kWidth-width)/2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(x, 64, width, itemW) collectionViewLayout:layout];
    [self.contentView addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[JoinUserIconCollectionViewCell class] forCellWithReuseIdentifier:@"cell2"];
    

}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {

    JoinUserIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
    
    cell.iconImg.layer.cornerRadius = 20;
    cell.titleLab.layer.cornerRadius = 7;
    cell.titleLab.layer.masksToBounds= YES;
    cell.iconImg.layer.masksToBounds= YES;
    
    if (indexPath.item != 0) {
        cell.titleLab.hidden = YES;
    }
    
    NSString *str =[_goodsDetail.in_user[indexPath.item] objectForKey:@"image"];
    cell.iconImg.layer.borderColor = MainColor.CGColor;
    cell.iconImg.layer.borderWidth = 1;
    [cell.iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:str]];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSUInteger count = [self.goodsDetail.group_num integerValue];
    return count;
    
}

@end
