//
//  AuthorWorkListTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorWorkListTableViewCell.h"
#import "AuthorWorkCollectionViewCell.h"

@interface AuthorWorkListTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic)  UICollectionView *collectionView;

@end

@implementation AuthorWorkListTableViewCell

+(instancetype)authorWorkListTableViewCell:(NSArray *)data{
    
    AuthorWorkListTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"AuthorWorkListTableViewCell" owner:self options:nil][0];
    instance.dataAry = data;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(42, 42);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, Space);
    instance.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15, 50, kWidth-45, 42) collectionViewLayout:layout];
    [instance.contentView addSubview:instance.collectionView];
    instance.collectionView.delegate = instance;
    instance.collectionView.dataSource = instance;
    instance.collectionView.backgroundColor = [UIColor whiteColor];
    [instance.collectionView registerClass:[AuthorWorkCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    instance.collectionView.scrollEnabled = NO;
    instance.collectionView.userInteractionEnabled = NO;
    return instance;
    
}




- (IBAction)nextPage:(UIButton *)sender {
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (_dataAry.count == 0) {
        AuthorWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.workImg.image = [UIImage imageNamed:@"添加"];
        return cell;
    }
    
    AuthorWorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.workImg sd_setImageWithURL:[NSURL URLWithString:_dataAry[indexPath.item]]];
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_dataAry.count == 0) {
        return 1;
    }
    
    return _dataAry.count;
}




@end
