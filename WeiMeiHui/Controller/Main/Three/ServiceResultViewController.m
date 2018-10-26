//
//  ServiceResultViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ServiceResultViewController.h"
#import "FamousGoodsTableViewCell.h"

#import "GBTagListView.h"
#import "HWDownSelectedView.h"

#import "GoodsDetailViewController.h"

@interface ServiceResultViewController ()<HWDownSelectedViewDelegate>

@property(nonatomic,strong) NSMutableArray *servicedataAry;

@property (strong, nonatomic) GBTagListView *bubbleView;
@property (strong, nonatomic)  HWDownSelectedView *down1;

@property (copy, nonatomic) NSArray *tagAry;
@property (copy, nonatomic) NSArray *selectAry;

@property (strong, nonatomic)  UIView *tagBgView;
@property (assign, nonatomic)  NSUInteger selectIndex;

@end

@implementation ServiceResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.servicedataAry =[NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, kWidth, kHeight-SafeAreaBottomHeight-SafeAreaHeight-88-44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //    self.tableView.style = UITableViewStyleGrouped;
    // 代理&&数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    //    加刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refreshData:1];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self refreshMoreData:1];
    }];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        
    }
    
    _tagBgView = [[UIView alloc] init];
    _tagBgView.backgroundColor = [UIColor whiteColor];
//    _tagBgView.frame = CGRectMake(0, 0, kWidth, 44);
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData:(NSUInteger)page{
    
    self.page = 1;
    [self getDataAtIndex:1];
    
}

- (void)refreshMoreData:(NSUInteger)page{
    self.page ++;
    [self getDataAtIndex:1];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.servicedataAry.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        FamousGoodsTableViewCell *cell = [FamousGoodsTableViewCell  famousGoodsTableViewCellSearch];
        cell.goodsSearch = [AuthorGoods authorGoodsWithDict:self.servicedataAry[indexPath.row]];
        return cell;
    
}


- (void)getDataAtIndex:(NSUInteger)tag{
    
    
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    if (!uuid) {
        uuid = @"";
    }
    
    if (!city_id.length) {
        city_id = @"";
    }
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":@"2",@"lat":lat,@"lng":lng,@"page":@(self.page),@"dump_id":self.dump_id,@"intelligent":self.intelligent,@"grade":self.grade,@"tag_id":self.tag_id,@"content":self.content,@"cut_id":self.cut_id}];
    
    [YYNet POST:SearchREsultsN paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        
        
        if ([[[dic objectForKey:@"select_data"] objectForKey:@"tag_data"] isKindOfClass:[NSArray class]]) {
            
            self.tagAry = [[dic objectForKey:@"select_data"] objectForKey:@"tag_data"];
            [self.tagBgView addSubview:self.bubbleView];
            self.tagBgView.frame = CGRectMake(0, 0, kWidth, self.bubbleView.frame.size.height+Space);
            [self.view addSubview:self.tagBgView];
        }
        
        [self addDownView];
        
        if ([[[dic objectForKey:@"select_data"] objectForKey:@"author_grade"] isKindOfClass:[NSArray class]]) {
            
            
            self.selectAry = [[dic objectForKey:@"select_data"] objectForKey:@"author_grade"];
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.selectAry) {
                [temp addObject:obj[@"name"]];
            }
            
            self.down1.listArray = temp;
            self.down1.selectedIndex = self.selectIndex;
            
        }
        
        if ([[dic objectForKey:@"goods"] isKindOfClass:[NSArray class]]) {
            
            if (self.page == 1) {
                [self.servicedataAry setArray:[dic objectForKey:@"goods"]];
            }else{
                [self.servicedataAry addObjectsFromArray:[dic objectForKey:@"goods"]];
            }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
       
            NSArray *temp = [dic objectForKey:@"goods"];
            if (temp.count < 10) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        
        if (self.servicedataAry.count== 0) {
            MJWeakSelf
            self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"搜索空" titleStr:@"" detailStr:@"" btnTitleStr:@"" btnClickBlock:^{
                [weakSelf getDataAtIndex:0];
            }];
        }
        
    } faild:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        MJWeakSelf
        self.tableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getDataAtIndex:2];
        }];
        
        
    }];
    
}

- (void)addDownView{
    
    if (self.down1) {
        return;
    }
    
    UIView *v= [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tagBgView.frame), kWidth, 44)];
    v.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:v];
    
    HWDownSelectedView *down = [[HWDownSelectedView alloc]init];
    down.backgroundColor = [UIColor groupTableViewBackgroundColor];
     [self.view addSubview:down];
    
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/4);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(v.mas_right).offset(-Space);
        make.top.mas_equalTo(v.mas_top).offset(0);
    }];
    
    down.delegate = self;
    down.tag = 1;
    self.down1 = down;
    
}

- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath{
    
    self.selectIndex = indexPath.row;
    
    self.grade = [self.selectAry[indexPath.row] objectForKey:@"id"];
    [self.tableView.mj_header beginRefreshing];
    
}

- (GBTagListView *)bubbleView{
    
    if (!_bubbleView) {
        
        _bubbleView = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 10, kWidth, 44)];
        /**允许点击 */
        _bubbleView.canTouch=YES;
        /**控制是否是单选模式 */
        _bubbleView.isSingleSelect=YES;
        _bubbleView.signalTagColor=[UIColor whiteColor];
        [_bubbleView setMarginBetweenTagLabel:20 AndBottomMargin:12];
        
        MJWeakSelf
        _bubbleView.didselectItemBlock = ^(NSArray *arr) {
            
            if (!arr.count) {
                return ;
            }
            
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *name in weakSelf.tagAry) {
                
                [temp addObject:name[@"name"]];
                
            }
            
            NSUInteger index = [temp indexOfObject:arr[0]];
            weakSelf.tag_id = [weakSelf.tagAry[index] objectForKey:@"id"];
            [weakSelf.tableView.mj_header beginRefreshing];
            
        };
        
    }
    
    return _bubbleView;
}

- (void)setTagAry:(NSArray *)tagAry{
    
    _tagAry = tagAry;
    [self.bubbleView removeFromSuperview];
    self.bubbleView = nil;
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSDictionary *obj in tagAry) {
        [temp addObject:obj[@"name"]];
    }
    
    [self.bubbleView setTagWithTagArray:temp];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 88;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
//    return 88;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
//    return self.tagBgView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *temp = [self.servicedataAry[indexPath.row] objectForKey:@"id"];
    
    GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
    detailVc.ID = temp;
    detailVc.isGroup = [[self.servicedataAry[indexPath.row] objectForKey:@"is_group"] integerValue];
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}

@end
