//
//  CouponAlertview.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponAlertViewDelegate <NSObject>

- (void)couponAlertViewshouldDismiss;
- (void)couponAlertViewdidSelectAtIndex:(NSUInteger)index;


@end

@interface CouponAlertView : UIView <UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, copy) NSArray *dataAry;
@property (nonatomic, weak) id <CouponAlertViewDelegate>delegate;
@property (strong, nonatomic)  NSMutableDictionary *heightDic;

+ (instancetype)couponAlertviewWithFrame:(CGRect)frame;

@end
