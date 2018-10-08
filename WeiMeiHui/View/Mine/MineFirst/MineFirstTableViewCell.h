//
//  MineFirstTableViewCell.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/3/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *count;
+(instancetype)mineFirstTableViewCell;
@end
