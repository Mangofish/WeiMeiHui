//
//  ValueCardsPayViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/11/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ValueCardsPayViewController : UIViewController

/**
 商品ID
 */
@property (nonatomic,copy)NSString *ID;


/**
 订单类型
 */
@property (nonatomic,assign) NSUInteger type;


/**
 商家ID
 */
@property (nonatomic,copy)NSString *shopID;

@end

NS_ASSUME_NONNULL_END
