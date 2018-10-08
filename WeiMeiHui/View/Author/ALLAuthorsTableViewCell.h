//
//  ALLAuthorsTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopAuthor.h"
#import "AuthorGoods.h"
#import "GoodsDetail.h"
//@protocol AuthorsTableViewCellDelegate <NSObject>
//- (void)didClickMenuIndex:(NSInteger)index;
//- (void)didClickIconIndex:(NSInteger)index;
//@end

@interface ALLAuthorsTableViewCell : UITableViewCell

+(instancetype)allAuthorsTableViewCell;
+(instancetype)allAuthorsTableViewCellSecond;

@property(strong,nonatomic) ShopAuthor *author;
@property(strong,nonatomic) ShopAuthor *authorKill;
@property(strong,nonatomic) ShopAuthor *authorChoose;
@property(strong,nonatomic) AuthorGoods *goods;

@property(strong,nonatomic) GoodsDetail *goodsDetail;

@property(strong,nonatomic) GoodsDetail *goodsDetailOne;

//@property (nonatomic,   weak) id<AuthorsTableViewCellDelegate> delegate;



@end
