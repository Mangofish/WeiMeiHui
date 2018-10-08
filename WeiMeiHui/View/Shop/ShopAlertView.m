//
//  ShopAlertView.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/12.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopAlertView.h"

@implementation ShopAlertView

+(instancetype)shopAlertViewWithFrame:(CGRect)frame{
    
    ShopAlertView *instance =  [[NSBundle mainBundle] loadNibNamed:@"ShopAlertView" owner:nil options:nil][0];
    instance.frame = frame;
    instance.mainTableView.delegate =  instance;
    instance.mainTableView.dataSource =  instance;
    instance.mainTableView.rowHeight = 44.0f;
    return instance;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataAry.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text =[self.dataAry[indexPath.row] objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
    
}

- (void)setDataAry:(NSArray *)dataAry{
    
    _dataAry = dataAry;
    [_mainTableView reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate didClickMenuIndex:indexPath.row];
    
}

- (IBAction)closeAction:(UIButton *)sender {
    [self.delegate dismiss];
}


@end
