//
//  AlreadyOrderTableViewCell.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainOrderStatusAlready.h"

@protocol AlreadyOrderTableViewCellDelegate <NSObject>

- (void)didClickMessageBtn:(NSUInteger)index;
- (void)didClickPayOrder:(NSInteger)index;
- (void)didClickIcon:(NSInteger)index;

@end

@interface AlreadyOrderTableViewCell : UITableViewCell

+(instancetype)alreadyOrderTableViewCell;

@property (nonatomic, copy) NSArray *tagAry;
@property(assign,nonatomic)CGFloat cellHeight;

@property(strong,nonatomic) MainOrderStatusAlready *order;

@property (weak, nonatomic) id <AlreadyOrderTableViewCellDelegate> delegate;

@end
