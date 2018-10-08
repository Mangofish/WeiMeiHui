//
//  AuthorWaitTableViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorOrdersModel.h"
#import "MainOrderStatusWait.h"
@protocol AuthorWaitTableViewCellDelegate <NSObject>

@optional

- (void)didClickMessageBtn:(NSUInteger)index;
- (void)didClickDelOrder:(NSInteger)index;
- (void)didClickTakeOrder:(NSInteger)index;
- (void)didClickAllowOrder:(NSInteger)index;
- (void)didClickIcon:(NSInteger)index;


@end

@interface AuthorWaitTableViewCell : UITableViewCell

+(instancetype)authorWaitTableViewCellWait;

@property(strong,nonatomic) AuthorOrdersModel *order;

@property(strong,nonatomic) MainOrderStatusWait *mainOrder;

@property(assign,nonatomic)CGFloat cellHeight;

+(instancetype)authorWaitTableViewCellYet;
+(instancetype)authorWaitTableViewCellCancel;
+(instancetype)authorWaitTableViewCellPayback;

@property(strong,nonatomic) AuthorOrdersModel *orderYet;
@property(strong,nonatomic) AuthorOrdersModel *orderchooseOther;
@property(strong,nonatomic) AuthorOrdersModel *orderCancel;
@property(strong,nonatomic) AuthorOrdersModel *orderPay;
@property(strong,nonatomic) AuthorOrdersModel *orderFinish;
@property(strong,nonatomic) AuthorOrdersModel *orderPayBack;
@property(strong,nonatomic) AuthorOrdersModel *orderPayBackFinish;
@property(strong,nonatomic) AuthorOrdersModel *orderPayBackReject;
@property(strong,nonatomic) AuthorOrdersModel *orderPayBackAllow;

@property(strong,nonatomic) AuthorOrdersModel *orderDetail;
@property(strong,nonatomic) AuthorOrdersModel *orderPayDetail;
@property (weak,nonatomic) id <AuthorWaitTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *countDownLab;
@property (weak, nonatomic) IBOutlet UILabel *statusPayBack;
- (void)setConfigWithSecond:(NSInteger)second;
- (void)setConfigWithSecondPay:(NSInteger)second;


@end
