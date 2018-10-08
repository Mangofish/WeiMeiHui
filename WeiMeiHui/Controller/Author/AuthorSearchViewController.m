//
//  AuthorSearchViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorSearchViewController.h"
#import "ALLAuthorsTableViewCell.h"
#import "AuthorDetailViewController.h"

@interface AuthorSearchViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_dataAry;
    NSUInteger page;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation AuthorSearchViewController

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
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-SafeAreaHeight-Space);
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self->page++;
        [self getData];
    }];
    
    [_mainTableView.mj_header beginRefreshing];
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _dataAry = [NSMutableArray array];
//    _heightDic = [NSMutableDictionary dictionary];
}

- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(page),@"grade":@"",@"nearby":@"",@"sequence":@"",@"content":_content}];
    
    [YYNet POST:MineAuthorLIST paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if (![dic[@"data"] isKindOfClass:[NSArray class]]) {
            [self->_mainTableView.mj_header endRefreshing];
            [self->_mainTableView.mj_footer endRefreshing];
            return ;
        }
        NSArray *temp = [dic objectForKey:@"data"];
        
        if (self->page == 1) {
            [self->_dataAry setArray:temp];
            
        }else{
            [self->_dataAry addObjectsFromArray:temp];
            
        }
        
        [self.mainTableView reloadData];
        
        if (temp.count<20) {
            
            [self->_mainTableView.mj_header endRefreshing];
            [self->_mainTableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [self->_mainTableView.mj_header endRefreshing];
            [self->_mainTableView.mj_footer endRefreshing];
            
        }
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
    
    ALLAuthorsTableViewCell *cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
    cell.tag = indexPath.section;
    
    cell.author = [ShopAuthor shopAuthorWithDict:_dataAry[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *uuid = [_dataAry[indexPath.section] objectForKey:@"uuid"];
    AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
    detailVc.ID = uuid;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

//头像
- (void)didClickIconIndex:(NSInteger)index{
    NSString *uuid = [_dataAry[index] objectForKey:@"uuid"];
    AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
    detailVc.ID = uuid;
    [self.navigationController pushViewController:detailVc animated:YES];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (IBAction)pop:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
