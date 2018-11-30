//
//  FamousGoodsTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorGoods.h"
#import "ZYLineProgressView.h"

@interface FamousGoodsTableViewCell : UITableViewCell

+ (instancetype)famousGoodsTableViewCell;

+ (instancetype)famousGoodsTableViewCellSale;

+ (instancetype)famousGoodsTableViewCellDetail;

+ (instancetype)famousGoodsTableViewCellDetailT;

+ (instancetype)famousGoodsTableViewCellSearch;

+ (instancetype)famousGoodsTableViewCellDetailS;

+ (instancetype)famousGoodsTableViewCellDetailSn;

+ (instancetype)famousGoodsTableViewCellDetailOrder;

+ (instancetype)famousGoodsTableViewCellDetailMain;

+ (instancetype)famousGoodsTableViewCellDetailShop;


@property(strong,nonatomic) AuthorGoods *goods;

@property(strong,nonatomic) AuthorGoods *goodsSearch;

@property(strong,nonatomic) AuthorGoods *goodsS;

@property(strong,nonatomic) AuthorGoods *goodsO;
@property(strong,nonatomic) AuthorGoods *goodsShop;

@property (weak, nonatomic) IBOutlet UIView *redView;
@property (strong, nonatomic)  ZYLineProgressView *progressView;

@end
