//
//  ShopAlertView.h
//  WeiMeiHui
//
//  Created by apple on 2018/5/12.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopAlertViewDelegate <NSObject>


- (void)didClickMenuIndex:(NSInteger)index;
- (void)dismiss;

@end

@interface ShopAlertView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic,   weak) id<ShopAlertViewDelegate> delegate;
@property (copy, nonatomic) NSArray *dataAry;

+ (instancetype)shopAlertViewWithFrame:(CGRect)frame;;

@end
