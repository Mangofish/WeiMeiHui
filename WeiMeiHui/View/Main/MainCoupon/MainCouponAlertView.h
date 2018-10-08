//
//  MainCouponAlertView.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainCouponAlertViewDelegate <NSObject>


- (void)didClickRecieve;
- (void)dismiss;

@end

@interface MainCouponAlertView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  NSMutableDictionary *heightDic;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *recieveBtn;

@property (copy, nonatomic) NSArray *dataAry;
@property (copy, nonatomic) NSString *imgUrl;

+ (instancetype)mainCouponAlertViewWithFrame:(CGRect)frame;

@property (nonatomic,   weak) id<MainCouponAlertViewDelegate> delegate;
@end
