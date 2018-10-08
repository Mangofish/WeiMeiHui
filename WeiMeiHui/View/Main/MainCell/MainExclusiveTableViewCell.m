//
//  MainExclusiveTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MainExclusiveTableViewCell.h"
#import "ExclusiveItemCollectionViewCell.h"

@implementation MainExclusiveTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemW = (kWidth-(kWidth*77/750)*2-(kWidth*72/750)*2)/4;
        
        layout.itemSize = CGSizeMake(itemW, 80);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kWidth*77/750, 0, kWidth-(kWidth*77/750)*2, 80) collectionViewLayout:layout];
        [self.contentView addSubview:_collectionView];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ExclusiveItemCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    
    return self;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    ExclusiveItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *pic = [_goodsAry[indexPath.item] objectForKey:@"pic"];
    NSString *name = [_goodsAry[indexPath.item] objectForKey:@"name"];
    
    [cell.img sd_setImageWithURL:[NSURL urlWithNoBlankDataString:pic] placeholderImage:[UIImage imageNamed:@"test"]];
     cell.nameLab.text = name;
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    NSUInteger count = [self.goodsDetail.group_num integerValue];
    return self.goodsAry.count;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegete didClickMenuIndex:indexPath.item];
    
}
@end
