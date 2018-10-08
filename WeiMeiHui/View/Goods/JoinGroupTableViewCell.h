//
//  JoinGroupTableViewCell.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodsDetail.h"

@protocol JoinGroupTableViewCellDelegate <NSObject>

- (void)didSelectJoinGroup;

@end

@interface JoinGroupTableViewCell : UITableViewCell

+(instancetype)joinGroupTableViewCell;

@property(strong,nonatomic) GoodsDetail *goodsDetail;
@property(strong,nonatomic) GoodsDetail *goodFailDetail;
@property(strong,nonatomic) GoodsDetail *goodsWaitDetail;

@property(weak,nonatomic) id<JoinGroupTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@end
