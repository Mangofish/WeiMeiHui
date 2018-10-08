//
//  CommentTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiHeadView.h"
#import "CommentList.h"
#import "WeiContent.h"

@interface CommentTableViewCell : UITableViewCell
@property (nonatomic,strong) CommentList *model;
@property (nonatomic,strong) WeiContent *modelHome;
@property(assign,nonatomic)CGFloat cellHeight;

@property (nonatomic,strong) WeiHeadView *headView;//头部view

@end
