//
//  SeKillsCollectionViewCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SeKillsCollectionViewCellDelegate <NSObject>

- (void)didClickAlarmMenuIndex:(NSInteger)index andData:(NSArray *)data;

- (void)didClickMenuIndex:(NSInteger)index andData:(NSArray *)data;

- (void)didClickMenuIndex:(NSInteger)index andData:(NSArray *)data status:(NSString *)status;
@end


#import "SecondsKillTableViewCell.h"

@interface SeKillsCollectionViewCell : UICollectionViewCell <UITableViewDataSource, UITableViewDelegate,SecondsKillTableViewCellDelegate>

//tableView
@property (nonatomic, strong)UITableView *tableView;
//tableView数组
@property (nonatomic, strong)NSMutableArray *dataTableArray;

@property (nonatomic, copy) NSString *status;

@property (nonatomic,   weak) id<SeKillsCollectionViewCellDelegate> delegate;
@end
