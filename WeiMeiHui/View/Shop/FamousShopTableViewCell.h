//
//  FamousShopTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopAndAuthor.h"

@interface FamousShopTableViewCell : UITableViewCell

@property(strong,nonatomic) ShopAndAuthor *author;

@property(strong,nonatomic) ShopAndAuthor *authorMain;
@property(strong,nonatomic) ShopAndAuthor *authorExclusive;

+ (instancetype)famousShopTableViewCell;
+ (instancetype)famousShopTableViewCellMain;
+ (instancetype)famousShopTableViewCellExclusive;
@end
