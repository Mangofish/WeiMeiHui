//
//  GroupGoodsListsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GroupGoodsListsViewController.h"
#import "HWDownSelectedView.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "AuthorDetailViewController.h"
#import "WeiJoinGroupViewController.h"


@interface GroupGoodsListsViewController () <UITableViewDataSource,UITableViewDelegate,HWDownSelectedViewDelegate>
{
    NSString *nearby;
    NSString *grade;
    NSString *price;
    
    NSUInteger nearbyIndex;
    NSUInteger gradeIndex;
    NSUInteger priceIndex;
    
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *downBgView;

@property (copy, nonatomic)  NSMutableArray *filtrateAry;
@property (copy, nonatomic)  NSMutableArray *nearbyAry;
@property (copy, nonatomic)  NSMutableArray *gradeAry;
@property (strong, nonatomic)  NSMutableArray *dataAry;
@property (assign, nonatomic)  NSUInteger page;
@property (strong, nonatomic)  HWDownSelectedView *down1;
@property (strong, nonatomic)  HWDownSelectedView *down2;
@property (strong, nonatomic)  HWDownSelectedView *down3;

@end

@implementation GroupGoodsListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    nearby = @"";
    grade = @"";
    price = @"";
    [self configUI];
}

- (void)configUI{
    
    _bgView.frame = CGRectMake(0, 0, kWidth,SafeAreaHeight);
    _downBgView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth,44);
    
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
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+44, kWidth, kHeight-SafeAreaHeight-44);
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getData];
    }];
    
    [_mainTableView.mj_header beginRefreshing];
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _dataAry = [NSMutableArray array];
    _gradeAry = [NSMutableArray array];
    _nearbyAry = [NSMutableArray array];
    _filtrateAry = [NSMutableArray array];
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:down];
    
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/3);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.downBgView.mas_top).offset(0);
    }];
    down.delegate = self;
    down.tag = 1;
    self.down1 = down;
    
    HWDownSelectedView *downv = [HWDownSelectedView new];
    downv.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:downv];
    //    down.frame = CGRectMake(kWidth-100-Space, SafeAreaTopHeight-10, 100, 40);
    [downv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/3);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(kWidth/3);
        make.top.mas_equalTo(self.downBgView.mas_top).offset(0);
    }];
    downv.delegate = self;
    downv.tag = 2;
    self.down2 = downv;
    
    HWDownSelectedView *downV = [HWDownSelectedView new];
    downV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downV];
    
    [downV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/3);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(2*kWidth/3);
        make.top.mas_equalTo(self.downBgView.mas_top).offset(0);
    }];
    downV.delegate = self;
    downV.tag = 3;
    self.down3 = downV;
}

- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
   
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"city_id":city_id,@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(self.page),@"nearby":nearby,@"grade":grade,@"price":price}];
    
    [YYNet POST:MainpatGroup paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        NSDictionary *dataDic = dic[@"data"];
        
        if ([dataDic[@"author_list"] isKindOfClass:[NSArray class]]) {
            
            if (self.page == 1) {
                [self.dataAry setArray:dataDic[@"author_list"]];
                
            }else{
                [self.dataAry addObjectsFromArray:dataDic[@"author_list"]];
            }
            
        }
        
        if (self.dataAry.count == 0) {
//            暂时没有拼团
            
            self.mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"暂时没有拼团"
                                                                    titleStr:@""
                                                                   detailStr:@""];
            
        }
        
        
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        [self.mainTableView reloadData];
        
      
        
        if ([[dic[@"data"] objectForKey:@"author_grade"] isKindOfClass:[NSArray class]]) {
            
            [self.gradeAry setArray:[dic[@"data"] objectForKey:@"author_grade"]];
            
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.gradeAry) {
                [temp addObject:obj[@"name"]];
            }
            
            self.down2.selectedIndex = self->gradeIndex;
            self.down2.listArray = temp;
        }
       
        if ([[dic[@"data"] objectForKey:@"price_list"] isKindOfClass:[NSArray class]]) {
            
            [self.filtrateAry setArray:[dic[@"data"] objectForKey:@"price_list"]];
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.filtrateAry) {
                [temp addObject:obj[@"name"]];
            }
        
            
            self.down3.selectedIndex = self->priceIndex;
            self.down3.listArray = temp;
            
        }
       
        if ([[dic[@"data"] objectForKey:@"nearby"] isKindOfClass:[NSArray class]]) {
            
            [self.nearbyAry setArray:[dic[@"data"] objectForKey:@"nearby"]];
            
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.nearbyAry) {
                [temp addObject:obj[@"name"]];
            }
            
            
            self.down1.selectedIndex = self->nearbyIndex;
            self.down1.listArray = temp;
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    发起人
    if (indexPath.row == 0) {
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFive];
        cell.groupList = [GoodsDetail authorGoodsWithDict:self.dataAry[indexPath.section]];
        return cell;
        
        //        商品名
    }else if (indexPath.row == 1 ){
        
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFour];
        cell.groupList = [GoodsDetail authorGoodsWithDict:self.dataAry[indexPath.section]];
        return cell;
        
    }else if (indexPath.row == 2){
        
        //            手艺人
        ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (cell == nil) {
            cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
        }
        
        cell.author = [ShopAuthor shopAuthorWithDict:self.dataAry[indexPath.section]];
        return cell;
        
    }else{
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 60;
    }
    
    if (indexPath.row == 1) {
        return 60;
    }
    
    if (indexPath.row == 2) {
        return 88;
    }
    
    if (indexPath.row == 3) {
        return 44;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 ) {
        
        
        WeiJoinGroupViewController *weiVC = [[WeiJoinGroupViewController alloc]init];
        weiVC.ID = [_dataAry[indexPath.section] objectForKey:@"order_number"];
        weiVC.goodsID = [_dataAry[indexPath.section] objectForKey:@"goods_id"];
        [self.navigationController pushViewController:weiVC animated:YES];
        
    }else if (indexPath.row == 2 ) {
        
       NSString *uuid  = [_dataAry[indexPath.section] objectForKey:@"author_uuid"];
        
        AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
        detailVc.ID = uuid;
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }
    
}

#pragma mark - 下拉列表
- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath {
    
    //    附近
    if (selectedView.tag == 1) {
        
        nearby =  [self.nearbyAry[indexPath.row] objectForKey:@"id"];
        
        nearbyIndex = indexPath.row;
    }
    
    //    手艺人
    if (selectedView.tag == 2) {
        
        grade =  [self.gradeAry[indexPath.row] objectForKey:@"id"];;
        gradeIndex = indexPath.row;
    }
    
    //    筛选
    if (selectedView.tag == 3) {
        
        price =  [self.filtrateAry[indexPath.row] objectForKey:@"id"];;
        priceIndex = indexPath.row;
    }
    
    self.page = 1;
    [self.mainTableView.mj_header beginRefreshing];
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
