//
//  CardsUseLogViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CardsUseLogViewController.h"
#import "CardUseLogTableViewCell.h"
#import "ShopCardsCommentsViewController.h"

@interface CardsUseLogViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (copy, nonatomic) NSArray *dataAry;

@end

@implementation CardsUseLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
//        self->page = 1;
        [self getData];
    }];
//    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
////        self->page++;
//        [self getData];
//    }];
    
//    [_mainTableView.mj_header beginRefreshing];
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    _dataAry = [NSMutableArray array];
}

- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    //    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    //    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"order_number":self.ID}];
    
    [YYNet POST:MyCardsLog paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        NSArray *temp = @[];
        
        if ([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            temp = [dic objectForKey:@"data"];
        }
        
       
            
            if (temp.count == 0) {
                self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有关注"
                                                                            titleStr:@""
                                                                           detailStr:@""];
            }
            self.dataAry = temp;
            
        
        [self->_mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
//
//        if (temp.count<20) {
//
//            [self->_mainTableView.mj_header endRefreshing];
//            [self->_mainTableView.mj_footer endRefreshingWithNoMoreData];
//
//        }else{
//
//            [self->_mainTableView.mj_header endRefreshing];
//            [self->_mainTableView.mj_footer endRefreshing];
//
//        }
//
    
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
    
    CardUseLogTableViewCell *cell = [CardUseLogTableViewCell cardUseLogTableViewCell];
    cell.card = [ShopCardDetail shopCardDetailWithDict:self.dataAry[indexPath.section]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[self.dataAry[indexPath.section] objectForKey:@"status"] integerValue] == 0 ) {
        ShopCardsCommentsViewController *comVC = [[ShopCardsCommentsViewController alloc]init];
        comVC.ID = [self.dataAry[indexPath.section] objectForKey:@"log_id"];
        [self.navigationController pushViewController:comVC animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.mainTableView.mj_header beginRefreshing];
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
