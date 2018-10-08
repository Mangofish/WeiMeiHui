//
//  ErCodeOrderTableViewCell.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetail.h"
#import "ThreeOrder.h"

@interface ErCodeOrderTableViewCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *imger;
@property (weak, nonatomic) IBOutlet UILabel *orderNumer;


@property (weak, nonatomic) IBOutlet UILabel *dateLab;

+ (instancetype)erCodeOrderTableViewCell;
+ (instancetype)erCodeOrderTableViewCellEasy;
+ (instancetype)erCodeOrderTableViewCellTime;

@property (nonatomic, strong) ThreeOrder *goodsDetailEasy;
@property (nonatomic, strong) GoodsDetail *goodsDetail;
@end
