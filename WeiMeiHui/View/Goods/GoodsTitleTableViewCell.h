//
//  GoodsTitleTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodsDetail.h"
#import "ZYLineProgressView.h"

@interface GoodsTitleTableViewCell : UITableViewCell

+(instancetype)goodsTitleTableViewCell;
@property (strong, nonatomic)  ZYLineProgressView *progressView;
@property(strong,nonatomic) GoodsDetail *goodsDetail;

+(instancetype)goodsTitleTableViewCellKill;

@property (nonatomic, copy) NSArray * imagesURLAry;

@end
