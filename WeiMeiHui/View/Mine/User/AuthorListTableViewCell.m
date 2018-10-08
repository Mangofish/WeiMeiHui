//
//  AuthorListTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorListTableViewCell.h"
#import "ShopWithAuthorsCollectionViewCell.h"
@interface AuthorListTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,ShopWithAuthorsCellDelegate>


@property (strong, nonatomic)  UICollectionView *mainCollectionView;



@end

@implementation AuthorListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self configView];
        return self;
    }
    
    return self;
}

- (void)configView{
    
    [self.contentView addSubview:self.mainCollectionView];
    
}

- (UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        CGFloat cellWidth = 100;
     
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(cellWidth, cellWidth +64);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
        
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth, cellWidth +64) collectionViewLayout:layout];
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_mainCollectionView registerClass:[ShopWithAuthorsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        
    }
    return _mainCollectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _author.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopWithAuthorsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.followBtn.tag = indexPath.item;
    cell.author = [ShopAuthor shopAuthorWithDict:_author[indexPath.item]];
    cell.delegate = self;
    return cell;
    
}


-(void)setAuthor:(NSArray *)author{
    
    _author = author;
    [self.mainCollectionView reloadData];
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate selectAuthor:indexPath.item];
    
}

- (void)followingAction:(NSUInteger)index{
    
    [self.delegate followAction:index];
    
}

@end
