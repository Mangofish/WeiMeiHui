//
//  MineFirstTableViewCell.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/3/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MineFirstTableViewCell.h"

@implementation MineFirstTableViewCell

+ (instancetype)mineFirstTableViewCell{
    
    MineFirstTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"MineFirstTableViewCell" owner:nil options:nil][0];
    cell.frame = CGRectMake(0, 0, kWidth, 44);
    return cell;
}

@end
