//
//  FamousShopTitleTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopAndAuthor.h"

@protocol FamousShopTitleTableViewCellDelegate <NSObject>

- (void)locationAction;

@end

@interface FamousShopTitleTableViewCell : UITableViewCell

@property(strong,nonatomic) ShopAndAuthor *author;

@property(strong,nonatomic) ShopAndAuthor *authorSingle;

+ (instancetype)famousShopTitleTableViewCell;
+ (instancetype)famousShopTitleTableViewCellSingle;

@property (nonatomic, copy) NSArray * imagesURLAry;
@property (nonatomic, assign) id <FamousShopTitleTableViewCellDelegate> delegate;


@end
