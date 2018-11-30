//
//  AuthorGoodsListsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorGoodsListsViewController.h"
#import "HWDownSelectedView.h"
#import "ALLAuthorsTableViewCell.h"
#import "AuthorGoodsItemTableViewCell.h"
#import "AuthorDetailViewController.h"
#import "GoodsDetailViewController.h"

@interface AuthorGoodsListsViewController ()<UITableViewDataSource,UITableViewDelegate,AuthorGoodsItemTableViewCellDelegate,HWDownSelectedViewDelegate>

{
    NSString *sequence;
    NSString *nearby;
    
    NSUInteger nearbyIndex;
    NSUInteger sequenceIndex;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *downBgView;

@property (copy, nonatomic)  NSMutableArray *sequenceAry;
@property (copy, nonatomic)  NSMutableArray *nearbyAry;

@property (strong, nonatomic)  NSMutableArray *dataAry;

@property (assign, nonatomic)  NSUInteger page;
@property (strong, nonatomic)  HWDownSelectedView *down1;
@property (strong, nonatomic)  HWDownSelectedView *down2;
@end

@implementation AuthorGoodsListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    sequence = @"";
    nearby = @"";
}

- (void)configUI{
    
    _bgView.frame = CGRectMake(0, 0, kWidth,SafeAreaHeight);
   _downBgView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth,44);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);、
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
    
    self.titleLab.text = self.titleStr;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+Space+44, kWidth, kHeight-SafeAreaHeight-Space-44);
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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
    _sequenceAry = [NSMutableArray array];
    _nearbyAry = [NSMutableArray array];
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:down];
    
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
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
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(kWidth/2);
        make.top.mas_equalTo(self.downBgView.mas_top).offset(0);
    }];
    downv.delegate = self;
    downv.tag = 2;
    self.down2 = downv;
    
   
}

- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(self.page),@"city_id":city_id,@"sequence":sequence,@"nearby":nearby,@"type":self.type,@"activity_id":self.activityID}];
    
    [YYNet POST:MobileAuthorList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        NSDictionary *dataDic = dic[@"data"];
        
        if ([dataDic[@"author_list"] isKindOfClass:[NSArray class]]) {
            
            if (self.page == 1) {
                [self.dataAry setArray:dataDic[@"author_list"]];
                
            }else{
                [self.dataAry addObjectsFromArray:dataDic[@"author_list"]];
            }
            
        }
        
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        [self.mainTableView reloadData];
        
      
        
        if ([[dic[@"data"] objectForKey:@"intelligent"] isKindOfClass:[NSArray class]]) {
            
            [self.sequenceAry setArray:[dic[@"data"] objectForKey:@"intelligent"]];
            
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.sequenceAry) {
                [temp addObject:obj[@"name"]];
            }
            
            self.down2.selectedIndex = self->sequenceIndex;
            self.down2.listArray = temp;
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
        
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *temp = [_dataAry[section] objectForKey:@"author_goods"];
    
    return temp.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (cell == nil) {
            cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
        }
        cell.author = [ShopAuthor shopAuthorWithDict:_dataAry[indexPath.section]];
        return cell;
        
    }else{
        
        AuthorGoodsItemTableViewCell *cell = [AuthorGoodsItemTableViewCell authorGoodsItemTableViewCell];
        cell.delegate = self;
        cell.tag = indexPath.section;
        NSDictionary *temp = [[self.dataAry[indexPath.section] objectForKey:@"author_goods"] objectAtIndex:indexPath.row-1];
        cell.goods = [AuthorGoods authorGoodsWithDict:temp];
        return cell;
        
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 88;
    }
    
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 ) {
        
        NSString *uuid = [_dataAry[indexPath.section] objectForKey:@"author_uuid"];
        AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
        detailVc.ID = uuid;
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }else{
        
        NSArray *temp = [_dataAry[indexPath.section] objectForKey:@"author_goods"];
        
        NSString *uuid = [temp[indexPath.row-1] objectForKey:@"id"];
        GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
        detailVc.ID = uuid;
        detailVc.isGroup = [[temp[indexPath.row-1] objectForKey:@"is_group"] integerValue];
        [self.navigationController pushViewController:detailVc animated:YES];
        
    }
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
        sequence =  [self.sequenceAry[indexPath.row] objectForKey:@"id"];;
        sequenceIndex = indexPath.row;
    }
    
    
    
    self.page = 1;
    [self.mainTableView.mj_header beginRefreshing];
    
}


@end
