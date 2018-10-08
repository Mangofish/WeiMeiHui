//
//  MyOrderListTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyOrderList.h"

@interface MyOrderListTableViewCell : UITableViewCell

@property(strong,nonatomic) MyOrderList *order;
@property(strong,nonatomic) MyOrderList *orderDetail;

+(instancetype)myOrderListTableViewCell;

@property(assign,nonatomic)CGFloat cellHeight;
@end
