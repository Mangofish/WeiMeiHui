//
//  GoodsDetailSmallTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetail.h"
#import "AuthorGoods.h"

@interface GoodsDetailSmallTableViewCell : UITableViewCell

+(instancetype)goodsDetailSmallTableViewCellOne;
+(instancetype)goodsDetailSmallTableViewCellTwo;
+(instancetype)goodsDetailSmallTableViewCellThree;
+(instancetype)goodsDetailSmallTableViewCellFour;
+(instancetype)goodsDetailSmallTableViewCellFive;

+(instancetype)goodsDetailSmallTableViewCellOrder;
+(instancetype)goodsDetailSmallTableViewCellWeiOrder;
+(instancetype)goodsDetailSmallTableViewCellOrderComment;

@property(strong,nonatomic) GoodsDetail *orderDetail;
@property(strong,nonatomic) GoodsDetail *groupList;
@property(strong,nonatomic) GoodsDetail *goodsDetail;
@property(strong,nonatomic) AuthorGoods *goods;
@property(strong,nonatomic) GoodsDetail *order;
@property(strong,nonatomic) GoodsDetail *weiorder;
@property(strong,nonatomic) GoodsDetail *killorder;
@property(strong,nonatomic) GoodsDetail *orderComment;
//@property (weak, nonatomic) IBOutlet UIButton *imgBtn;

@property(strong,nonatomic) GoodsDetail *realorder;

@property (weak, nonatomic) IBOutlet UILabel *status;

@end
