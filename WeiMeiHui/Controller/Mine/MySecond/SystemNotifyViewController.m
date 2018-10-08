//
//  SystemNotifyViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SystemNotifyViewController.h"
#import "SystemNotifyTableViewCell.h"
#import "NotifyDetailViewController.h"

@interface SystemNotifyViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_dataAry;
    NSUInteger page;
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation SystemNotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self configNavView];
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);
//        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight-Space);
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getData];
    }];
//    _mainTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        page++;
//        [self getData];
//    }];
    
    [_mainTableView.mj_header beginRefreshing];
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _dataAry = [NSMutableArray array];
    
    
}

- (void)getData{
    
    //网络请求
//    NSString *uuid = @"";
//    if ([PublicMethods isLogIn]) {
//        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
//    }
//    
//    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
//    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
//    
//    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(page)}];
    
    [YYNet POST:MineNOTICE paramters:@{@"json":@""} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if (![dic[@"data"] isKindOfClass:[NSArray class]]) {
            [self->_mainTableView.mj_header endRefreshing];
            [self->_mainTableView.mj_footer endRefreshing];
            return ;
        }
        NSArray *temp = [dic objectForKey:@"data"];
        if (self->page == 1) {
            
            if (temp.count == 0) {
                self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有通知"
                                                                            titleStr:@""
                                                                           detailStr:@""];
            }
            
            [self->_dataAry setArray:temp];
            
        }else{
            [self->_dataAry addObjectsFromArray:temp];
            
        }
        
        [self.mainTableView reloadData];
        [self->_mainTableView.mj_header endRefreshing];
//        if (temp.count<20) {
//
//            [_mainTableView.mj_header endRefreshing];
//            [_mainTableView.mj_footer endRefreshingWithNoMoreData];
//
//        }else{
//
//            [_mainTableView.mj_header endRefreshing];
//            [_mainTableView.mj_footer endRefreshing];
//
//        }

        
    } faild:^(id responseObject) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SystemNotifyTableViewCell *cell = [SystemNotifyTableViewCell systemNotifyTableViewCell];
    NSDictionary *dic = _dataAry[indexPath.section];
    cell.name.text = dic[@"title"];
    cell.timeLab.text = dic[@"create_time"];
    cell.content = dic[@"intro"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 182;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotifyDetailViewController *notify = [[NotifyDetailViewController alloc]init];
    notify.content =  [_dataAry[indexPath.section] objectForKey:@"content"];
    [self.navigationController pushViewController:notify animated:YES];
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
