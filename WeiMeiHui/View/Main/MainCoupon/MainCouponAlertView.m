//
//  MainCouponAlertView.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MainCouponAlertView.h"
#import "CouponTableViewCell.h"

@implementation MainCouponAlertView

+(instancetype)mainCouponAlertViewWithFrame:(CGRect)frame{
    
    MainCouponAlertView *instance = [[NSBundle mainBundle] loadNibNamed:@"MainCouponAlertView" owner:nil options:nil][0];
    instance.frame = frame;
    instance.mainTableView.delegate = instance;
    instance.mainTableView.dataSource = instance;
    
    instance.recieveBtn.layer.cornerRadius = 4;
    instance.recieveBtn.layer.masksToBounds = YES;
    
    instance.layer.cornerRadius = 4;
    instance.layer.masksToBounds = YES;
    
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
    cell.coupon = [Coupon couponWithDict:self.dataAry[indexPath.section]];
    cell.erLab.hidden = YES;
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
    
    return 0.00001;
    
}

- (void)setImgUrl:(NSString *)imgUrl{
    
    [_titleImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:imgUrl] placeholderImage:[UIImage imageNamed:@"test2"]];
    
}

- (void)setDataAry:(NSArray *)dataAry{
    
    _dataAry = dataAry;
    [_mainTableView reloadData];
    
}

- (IBAction)closeAction:(UIButton *)sender {
    [self.delegate dismiss];
}


- (IBAction)recieveAction:(UIButton *)sender {
    [self.delegate didClickRecieve];
}

@end
