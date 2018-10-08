//
//  OrderTwoTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTwoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cusOrderNum;

@property (weak, nonatomic) IBOutlet UILabel *normalOrderNum;

+(instancetype)orderTwoTableViewCell;
@end
