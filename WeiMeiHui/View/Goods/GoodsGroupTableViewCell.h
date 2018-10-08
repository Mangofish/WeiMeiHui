//
//  GoodsGroupTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetail.h"
#import "RecentOrder.h"

@protocol GoodsGroupTableViewCellDelegate <NSObject>

- (void)didClickJoin;

@end

@interface GoodsGroupTableViewCell : UITableViewCell


+(instancetype)goodsGroupTableViewCellYellow;
+(instancetype)goodsGroupTableViewCellPink;
+(instancetype)goodsGroupTableViewCellTwo;
+(instancetype)goodsGroupTableViewCellThree;

@property(strong,nonatomic) GoodsDetail *goodsDetail;
@property(strong,nonatomic) RecentOrder *order;

@property(weak,nonatomic) id  <GoodsGroupTableViewCellDelegate>delegate;

- (void)setConfigWithSecond:(NSInteger)second;


@end
