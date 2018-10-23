//
//  EnableShopListsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "EnableShopListsViewController.h"
#import "JSDropDownMenu.h"
#import "ShopViewController.h"
#import "FamousShopTableViewCell.h"

@interface EnableShopListsViewController ()<UITableViewDelegate,UITableViewDataSource,JSDropDownMenuDelegate,JSDropDownMenuDataSource>
{
    
    
    NSUInteger page;
    
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    
    NSInteger _currentData1SelectedIndex;
    
    NSMutableArray *data1;
    NSMutableArray *data2;
    
    NSString *nearby;
    NSString *order;
    NSString *dumpID;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (copy, nonatomic) NSArray *nearbyAry;
@property (copy, nonatomic) NSArray *intellAry;
@property (strong, nonatomic) NSMutableArray *dataAry;

@property (nonatomic, strong) JSDropDownMenu *menu;

@property (assign, nonatomic) NSUInteger nearbyIndex;
@property (assign, nonatomic) NSUInteger intellIndex;

@end

@implementation EnableShopListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    order = @"";
    dumpID = @"";
    nearby = @"";
    
    self.dataAry = [NSMutableArray array];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self customUI];
}
    


- (IBAction)pop:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)customUI{
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+44, kWidth, kHeight-SafeAreaHeight-44);
    if (@available(iOS 11.0, *)) {
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
    _mainTableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
    _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self->page++;
        [self getData];
    }];
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(@(SafeAreaTopHeight));
    }];
    
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Space);
        make.top.equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
        make.height.equalTo(@(20));
        make.width.equalTo(@(kWidth-Space*2));
    }];
    
    
    page = 1;
    [_mainTableView.mj_header beginRefreshing];
}

- (void)getData{
    
    //网络请求
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    
    //    NSString *uuid = @"";
    //    if ([PublicMethods isLogIn]) {
    //        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    //    }
    
    NSString *url = [PublicMethods dataTojsonString:@{@"city_id":city_id,@"order":order,@"lat":lat,@"lng":lng,@"page":@(page),@"dump_id":dumpID,@"nearby":nearby,@"id":self.ID}];
    
    [YYNet POST:EnableShop paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        
        if ([[dic objectForKey:@"shop_list"] isKindOfClass:[NSArray class]]) {
            if (self->page == 1) {
                
                [self.dataAry setArray:[dic objectForKey:@"shop_list"]];
                
            }else{
                [self.dataAry addObjectsFromArray:[dic objectForKey:@"shop_list"]];
            }
            
        }
        
        if ([[dic objectForKey:@"dump_data"] isKindOfClass:[NSArray class]]) {
            
            NSArray *allData = [dic objectForKey:@"dump_data"];
            self.nearbyAry = allData;
            
            self->data1 = [NSMutableArray array];
            //            [self->data1 removeAllObjects];
            for (NSDictionary *obj in allData) {
                
                NSString *title = obj[@"area_name"];
                NSArray *ary = obj[@"dump_list"];
                
                NSMutableArray *rightTemp = [NSMutableArray array];
                
                for (int j=0 ; j<ary.count ; j++) {
                    
                    //                    [rightTemp addObject:ary[j][@"name"]];
                    NSString *fullName = @"";
                    
                    if ([[[ary objectAtIndex:j] objectForKey:@"shop_count"] integerValue] == 0) {
                        
                        fullName = [NSString stringWithFormat:@"%@",ary[j][@"name"]];
                    }else{
                        fullName = [NSString stringWithFormat:@"%@（%@）",ary[j][@"name"],ary[j][@"shop_count"]];
                    }
                    
                    
                    [rightTemp addObject:fullName];
                    
                }
                
                [self->data1 addObject:@{@"title":title, @"data":rightTemp}];
                
            }
        }
        
        
        if ([[dic objectForKey:@"intelligent"] isKindOfClass:[NSArray class]]) {
            
            self.intellAry = [dic objectForKey:@"intelligent"];
            
            self->data2 = [NSMutableArray array];
            
            for (NSDictionary *obj in self.intellAry) {
                [self->data2 addObject:obj[@"name"]];
            }
            
            
        }
        
        [self addSelectedView];
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataAry.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    return 1;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FamousShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main"];
    
    if (!cell) {
        cell = [FamousShopTableViewCell famousShopTableViewCellMain];
    }
    
    cell.authorMain = [ShopAndAuthor shopAuthorWithDict:self.dataAry[indexPath.section]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   return 189*(kWidth-20)/355+80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0000001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ShopViewController *shopVC = [[ShopViewController alloc]init];
    shopVC.ID = [self.dataAry[indexPath.section] objectForKey:@"id"];
    [self.navigationController pushViewController:shopVC animated:YES];
        
    
    
}

- (void)addSelectedView{
    
    // 指定默认选中
    _currentData1Index = 0;
    _currentData1SelectedIndex = 0;
    
    if (!_menu) {
        
        _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, SafeAreaHeight) andHeight:44];
        [self.view addSubview:_menu];
        //        [_menu mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.width.mas_equalTo(kWidth);
        //            make.height.mas_equalTo(44);
        //            make.right.mas_equalTo(self.view.mas_right).offset(0);
        //            make.top.mas_equalTo(self.view.mas_top).offset(0);
        //        }];
        _menu.textColor = FontColor;
        
        _menu.dataSource = self;
        _menu.delegate = self;
        
        
        
    }
    
    
}

#pragma mark - 下拉列表代理数据源
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
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
        
    } else {
        
        return data2.count;
        
    }
    
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    
    switch (column) {
        case 0: return [[data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
            break;
        case 1: return data2[_currentData2Index];
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
        
    } else{
        
        return data2[indexPath.row];
        
    }
    
}

#pragma mark- 点击选项刷新界面
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        //左边
        if(indexPath.leftOrRight==0){
            
            _currentData1Index = indexPath.leftRow;
            
            return;
            
        }else{
            
            _currentData1SelectedIndex = indexPath.row;
            
        }
        
        
        NSInteger leftRow = indexPath.leftRow;
        NSDictionary *menuDic = [self.nearbyAry objectAtIndex:leftRow];
        
        NSString *ID = [[[menuDic objectForKey:@"dump_list"] objectAtIndex:_currentData1SelectedIndex] objectForKey:@"id"];
        
        if (leftRow == 0) {
            
            nearby = ID;
            dumpID = @"";
            
        }else{
            
            dumpID = ID;
            nearby = @"";
        }
        
    }else if (indexPath.column==1) {
        
        _currentData2Index = indexPath.row;
        
        order = [self.intellAry[indexPath.row] objectForKey:@"id"];
        
    }
    
    [self.mainTableView.mj_header beginRefreshing];
    
}

@end
