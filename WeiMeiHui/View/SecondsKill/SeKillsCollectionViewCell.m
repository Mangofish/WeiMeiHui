//
//  SeKillsCollectionViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SeKillsCollectionViewCell.h"

#import "SecondsKillTableViewCell.h"

@implementation SeKillsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        //tableView
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.tableView];
        self.tableView.bounces = NO;
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self.tableView reloadData];
//        }];
//注册通知
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRemind:) name:@"reloadRemind" object:nil];
    }
    return self;
}

#pragma mark- 通知回调
- (void)reloadRemind:(NSNotification *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    
}

#pragma mark -- taleView  的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.dataTableArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellIdentifier = @"TableViewCell";
    SecondsKillTableViewCell *cell = nil;
    
    SecondKillGoods *goods = [SecondKillGoods goodsWithDict:self.dataTableArray[indexPath.section]];
    
//    未开始
    if ([self.status integerValue] == 0) {
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:goods.session_id]) {
            
            NSArray *temp = [[NSUserDefaults standardUserDefaults] valueForKey:goods.session_id];
            
            if ([temp containsObject:goods.ID]) {
                cell = [SecondsKillTableViewCell secondsKillTableViewCellCancel];
            }else{
                cell = [SecondsKillTableViewCell secondsKillTableViewCellRemind];
            }
                
            
        }else{
            
            cell = [SecondsKillTableViewCell secondsKillTableViewCellRemind];
            
        }
        
    }
    
//    抢购中
    if ([self.status integerValue] == 1) {
        
        if ([goods.inventory integerValue] == 0) {
            cell = [SecondsKillTableViewCell secondsKillTableViewCellSold];
        }else{
            cell = [SecondsKillTableViewCell secondsKillTableViewCell];
        }
        
    }
    
//    已结束
    if ([self.status integerValue] == 2) {
        cell = [SecondsKillTableViewCell secondsKillTableViewCellSold];
    }
   
    cell.tag = indexPath.section;
    cell.delegate = self;
    cell.goods = goods;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate didClickMenuIndex:indexPath.section andData:self.dataTableArray status:self.status];
    
}

- (void)didClickBuyIndex:(NSInteger)index{
    
    [self.delegate didClickMenuIndex:index andData:self.dataTableArray];
    
}


- (void)didClickMenuIndex:(NSInteger)index{
    
    [self.delegate didClickAlarmMenuIndex:index andData:self.dataTableArray];
    
}

@end
