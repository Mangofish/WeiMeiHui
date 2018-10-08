//
//  MyReplyTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorOrdersModel.h"

@interface MyReplyTableViewCell : UITableViewCell

@property(strong,nonatomic) AuthorOrdersModel *order;
+(instancetype)myReplyTableViewCell;
@property(assign,nonatomic)CGFloat cellHeight;
@end
