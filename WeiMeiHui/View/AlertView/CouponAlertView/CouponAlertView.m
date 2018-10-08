//
//  CouponAlertview.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CouponAlertView.h"

#import "CouponTableViewCell.h"


@implementation CouponAlertView

+(instancetype)couponAlertviewWithFrame:(CGRect)frame{
    
    CouponAlertView *instance = [[NSBundle mainBundle] loadNibNamed:@"CouponAlertView" owner:self options:nil][0];
    instance.frame = frame;
    instance.mainTableView.delegate = instance;
    instance.mainTableView.dataSource = instance;
    instance.heightDic = [NSMutableDictionary dictionary];
    return instance;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataAry.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponTableViewCell *cell = [CouponTableViewCell couponTableViewCell];
    cell.couponList = [Coupon couponWithDict:self.dataAry[indexPath.section]];
    _heightDic[@(indexPath.section)] = @(cell.cellHeight);
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     return [_heightDic[@(indexPath.section)] doubleValue];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
    
}

- (IBAction)dismiss:(UIButton *)sender {
    
    [self.delegate couponAlertViewshouldDismiss];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.delegate couponAlertViewshouldDismiss];
    [self.delegate couponAlertViewdidSelectAtIndex:indexPath.section];
    
}

- (void)setDataAry:(NSArray *)dataAry{
    
    _dataAry = dataAry;
    [_mainTableView reloadData];
    
}
@end
