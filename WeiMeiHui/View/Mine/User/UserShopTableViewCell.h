//
//  UserShopTableViewCell.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShopModel.h"

@protocol UserShopTableViewCellDelegate <NSObject>

- (void)didselectTel;
- (void)didselectLocation;
- (void)didselectMainPage;
- (void)didselectItem:(NSUInteger )index;


@end

@interface UserShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *itemBgView;
+ (instancetype)userShopTableViewCell;

+ (instancetype)userShopTableViewPriceCell;

@property(strong,nonatomic)ShopModel *model;

@property(strong,nonatomic)ShopModel *modelShop;

@property(strong,nonatomic)ShopModel *modelPrice;
@property(copy,nonatomic)NSArray *priceAry;
@property(weak,nonatomic)id <UserShopTableViewCellDelegate>delegate;

@end
