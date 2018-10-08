//
//  CommentOrderTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderComment.h"

@interface CommentOrderTableViewCell : UITableViewCell

@property(strong,nonatomic)OrderComment *comment;
@property(assign,nonatomic)CGFloat cellHeight;

+(instancetype)commentOrderTableViewCell;
+(instancetype)commentOrderTableViewCellWithPic;

@end
