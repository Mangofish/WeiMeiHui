//
//  OrderCompleteReplyTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderComment.h"

@interface OrderCompleteReplyTableViewCell : UITableViewCell

+ (instancetype)orderCompleteReplyTableViewCell;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic,copy) NSArray *finaStrTag;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic, strong) OrderComment *order;
@end
