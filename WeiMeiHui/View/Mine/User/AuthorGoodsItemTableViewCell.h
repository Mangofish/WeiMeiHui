//
//  AuthorGoodsItemTableViewCell.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorGoods.h"

@protocol AuthorGoodsItemTableViewCellDelegate <NSObject>

- (void)payAuthor:(NSUInteger)index;

@end

@interface AuthorGoodsItemTableViewCell : UITableViewCell

@property(strong,nonatomic) AuthorGoods *goods;
+ (instancetype)authorGoodsItemTableViewCell;

@property(weak,nonatomic)id <AuthorGoodsItemTableViewCellDelegate>delegate;
@end
