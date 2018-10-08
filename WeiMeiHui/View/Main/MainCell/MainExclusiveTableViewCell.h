//
//  MainExclusiveTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainExclusiveTableViewCellDelegate <NSObject>

- (void)didClickMenuIndex:(NSInteger)index;


@end

@interface MainExclusiveTableViewCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (copy, nonatomic) NSArray *goodsAry;

@property (weak, nonatomic) id <MainExclusiveTableViewCellDelegate>delegete;

@end
