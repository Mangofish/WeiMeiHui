//
//  BaseViewController.h
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AllSearchResultDelegate <NSObject>

- (void)didClickMoreIndex:(NSInteger)index;

@end

@interface BaseViewController : UMClickViewController <UITableViewDelegate,UITableViewDataSource>

- (void) refreshData:(NSUInteger)page;
- (void) refreshMoreData:(NSUInteger)page;

@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *tag_id;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *intelligent;
@property (nonatomic, copy) NSString *dump_id;
@property (nonatomic, copy) NSString *cut_id;
@property (nonatomic, copy) NSString *nearby;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, weak) id<AllSearchResultDelegate>delegate;
@end
