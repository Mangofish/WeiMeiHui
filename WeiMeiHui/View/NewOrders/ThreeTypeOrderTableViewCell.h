//
//  ThreeTypeOrderTableViewCell.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ThreeOrder.h"

@protocol ThreeTypeOrderTableViewCellDelegate <NSObject>


- (void)selectMoreAction;
- (void)checkAllAction;
- (void)checkStates:(NSUInteger)index;

@end


@interface ThreeTypeOrderTableViewCell : UITableViewCell

+ (instancetype)threeTypeOrderTableViewCell;
+ (instancetype)threeTypeOrderTableViewCellTitle;
+ (instancetype)threeTypeOrderTableViewCellHeader;
+ (instancetype)threeTypeOrderTableViewCellFooter;
+ (instancetype)threeTypeOrderTableViewCellFooterT;
+ (instancetype)threeTypeOrderTableViewCellHeaderAuthor;
+ (instancetype)threeTypeOrderTableViewCellFooterPay;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic,   weak) id<ThreeTypeOrderTableViewCellDelegate> delegate;
/**
 1.订制订单- 待接单
 */
@property (nonatomic, strong) ThreeOrder *cusWaitOrder;
/**
 2.订制订单- 已接单
 */
@property (nonatomic, strong) ThreeOrder *cusTakeOrder;

/**
 3.订制订单- 已支付
 */
@property (nonatomic, strong) ThreeOrder *cusPayOrder;
/**
 4.订制订单- 待评价
 */
@property (nonatomic, strong) ThreeOrder *cusCommentOrder;
/**
 5.订制订单- 退款中
 */
@property (nonatomic, strong) ThreeOrder *cusMoneyDuringOrder;
/**
 6.订制订单- 已退款
 */
@property (nonatomic, strong) ThreeOrder *cusMoneyPayBackOrder;
/**
 7.订制订单- 完成
 */
@property (nonatomic, strong) ThreeOrder *cusFinishOrder;
/**
 8.订制订单- 交易关闭
 */
@property (nonatomic, strong) ThreeOrder *cusRefuseOrder;

/**
 1.活动订单- 待支付
 */
@property (nonatomic, strong) ThreeOrder *activityWaitPayOrder;
/**
 2.活动订单- 待使用
 */
@property (nonatomic, strong) ThreeOrder *activityUseOrder;

/**
 3.活动订单- 待评价
 */
@property (nonatomic, strong) ThreeOrder *activityCommentOrder;
/**
 4.活动订单- 退款中
 */
@property (nonatomic, strong) ThreeOrder *activityMoneyDuringOrder;
/**
 5.活动订单- 已退款
 */
@property (nonatomic, strong) ThreeOrder *activityMoneyPayBackOrder;
/**
 6.活动订单- 已完成
 */
@property (nonatomic, strong) ThreeOrder *activityFinishOrder;


/**
 1.拼团订单- 待支付
 */
@property (nonatomic, strong) ThreeOrder *groupWaitPayOrder;
/**
 2.拼团订单- 未成团
 */
@property (nonatomic, strong) ThreeOrder *groupPeopleOrder;

/**
 2.拼团订单- 待使用
 */
@property (nonatomic, strong) ThreeOrder *groupUseOrder;

/**
 3.拼团订单- 待评价
 */
@property (nonatomic, strong) ThreeOrder *groupCommentOrder;
/**
 4.拼团订单- 退款中
 */
@property (nonatomic, strong) ThreeOrder *groupMoneyDuringOrder;
/**
 5.拼团订单- 已退款
 */
@property (nonatomic, strong) ThreeOrder *groupMoneyPayBackOrder;
/**
 6.拼团订单- 未拼成
 */
@property (nonatomic, strong) ThreeOrder *groupFailOrder;

/**
 6.拼团订单- 完成
 */
@property (nonatomic, strong) ThreeOrder *groupFinishOrder;

@end
