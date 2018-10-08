//
//  ShopResultsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopResultsViewController.h"
#import "FamousShopTableViewCell.h"
#import "JSDropDownMenu.h"
#import "ShopViewController.h"
@interface ShopResultsViewController ()<JSDropDownMenuDelegate,JSDropDownMenuDataSource>{
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    
    NSInteger _currentData1SelectedIndex;
    
    NSMutableArray *data1;
    NSMutableArray *data2;
    NSMutableArray *data3;

    
}

@property (strong, nonatomic)  NSMutableArray *nearbydataAry;
@property (strong, nonatomic)  NSMutableArray *servicedataAry;
@property (strong, nonatomic)  NSMutableArray *intelldataAry;
@property(nonatomic,strong) NSMutableArray *shopdataAry;
@property (nonatomic, strong) JSDropDownMenu *menu;
@property (strong, nonatomic)  UIView *dropView;

@end

@implementation ShopResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shopdataAry =[NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kWidth, kHeight-SafeAreaHeight-SafeAreaBottomHeight-88) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    //    self.tableView.style = UITableViewStyleGrouped;
    // 代理&&数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        
    }
    
    //    加刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refreshData:1];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self refreshMoreData:1];
    }];
    
    self.nearbydataAry = [NSMutableArray array];
    self.intelldataAry = [NSMutableArray array];
    self.servicedataAry = [NSMutableArray array];
    _dropView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    _dropView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dropView];
    
    [self getDataAtIndex:1];
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
    
    return self.shopdataAry.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    FamousShopTableViewCell *cell = [FamousShopTableViewCell famousShopTableViewCellMain];
    cell.authorMain = [ShopAndAuthor shopAuthorWithDict:self.shopdataAry[indexPath.section]];
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
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":@"4",@"lat":lat,@"lng":lng,@"page":@(self.page),@"dump_id":self.dump_id,@"intelligent":self.intelligent,@"grade":self.grade,@"tag_id":self.tag_id,@"content":self.content,@"cut_id":self.cut_id}];
    
    [YYNet POST:SearchREsultsN paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        
        
        if ([[dic[@"select_data"] objectForKey:@"dump_data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *allData = [dic[@"select_data"] objectForKey:@"dump_data"];
            [self.nearbydataAry setArray:allData];
            
            
            self->data1 = [NSMutableArray array];
            //            [self->data1 removeAllObjects];
            for (NSDictionary *obj in allData) {
                
                NSString *title = obj[@"area_name"];
                NSArray *ary = obj[@"dump_list"];
                
                NSMutableArray *rightTemp = [NSMutableArray array];
                
                for (int j=0 ; j<ary.count ; j++) {
                    
                    [rightTemp addObject:ary[j][@"name"]];
                    
                }
                
                [self->data1 addObject:@{@"title":title, @"data":rightTemp}];
                
            }
            
            
            
        }
        
        if ([[dic[@"select_data"] objectForKey:@"cut_data"] isKindOfClass:[NSArray class]]) {
            
            
            [self.servicedataAry setArray:[dic[@"select_data"] objectForKey:@"cut_data"]];
            
            self->data3 = [NSMutableArray array];
            
            for (NSDictionary *obj in self.servicedataAry) {
                [self->data3 addObject:obj[@"name"]];
            }
            
            
            
        }
        
        if ([[dic[@"select_data"] objectForKey:@"intelligent"] isKindOfClass:[NSArray class]]) {
            
            
            [self.intelldataAry setArray:[dic[@"select_data"] objectForKey:@"intelligent"]];
            
            self->data2 = [NSMutableArray array];
            
            for (NSDictionary *obj in self.intelldataAry) {
                [self->data2 addObject:obj[@"name"]];
            }
            
            
            
        }
        
        [self addSelectedView];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        
        if ([[dic objectForKey:@"shop"] isKindOfClass:[NSArray class]]) {
            
            
            if (self.page == 1) {
                [self.shopdataAry setArray:[dic objectForKey:@"shop"]];
            }else{
                [self.shopdataAry addObjectsFromArray:[dic objectForKey:@"shop"]];
            }
            
            NSArray *temp = [dic objectForKey:@"shop"];
            if (temp.count < 10) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        
        [self.tableView reloadData];
        
        if (self.shopdataAry.count== 0) {
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

- (void)addSelectedView{
    
    // 指定默认选中
    _currentData1Index = 0;
    _currentData1SelectedIndex = 0;
    
    if (!_menu) {
        
        _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
        [self.view addSubview:_menu];
        [_menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(44);
            make.right.mas_equalTo(self.view.mas_right).offset(0);
            make.top.mas_equalTo(self.view.mas_top).offset(0);
        }];
        _menu.textColor = FontColor;
        
        _menu.dataSource = self;
        _menu.delegate = self;
        
        
        
    }
    
    
}

#pragma mark - 下拉列表代理数据源
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.3;
    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    
        if (column==0) {
            
            return _currentData1Index;
            
        }
        if (column==1) {
            
            return _currentData2Index;
        }
        
        if (column==2) {
            
            return _currentData3Index;
            
        }
        
        
    
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        
        if (leftOrRight==0) {
            
            return data1.count;
        } else{
            
            NSDictionary *menuDic = [data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
        
    } else if (column==1){
        
        return data2.count;
        
    } else{
        
        return data3.count;
    }
    
 
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    
        switch (column) {
            case 0: return [[data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
                break;
            case 1: return data2[_currentData2Index];
                break;
            case 2: return data3[_currentData3Index];
                break;
           
            default:
                return nil;
                break;
        }
        
   
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        if (indexPath.leftOrRight==0) {
            
            NSDictionary *menuDic = [data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
            
        } else{
            
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
            
        }
        
    } else if (indexPath.column==1) {
        
        return data2[indexPath.row];
        
    } else {
        
        return data3[indexPath.row];
    }
    
}

#pragma mark- 点击选项刷新界面
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        NSInteger leftRow = indexPath.leftRow;
        NSDictionary *menuDic = [self.nearbydataAry objectAtIndex:leftRow];
        
        NSString *ID = [[[menuDic objectForKey:@"dump_list"] objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        if (leftRow == 0) {
            
            self.nearby = ID;
            
        }else{
            
            self.dump_id = ID;
            
        }
        
    }else if (indexPath.column==1) {
        
        _currentData2Index = indexPath.row;
        
        self.intelligent = [self.intelldataAry[indexPath.row] objectForKey:@"id"];
        
    } else {
        
        _currentData3Index = indexPath.row;
        self.cut_id = [self.servicedataAry[indexPath.row] objectForKey:@"id"];
    }
    
    [self.tableView.mj_header beginRefreshing];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 189*(kWidth-20)/355+80;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    
    return 0.000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
  
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopViewController *shopVC = [[ShopViewController alloc]init];
    shopVC.ID = [self.shopdataAry[indexPath.section] objectForKey:@"id"];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

@end
