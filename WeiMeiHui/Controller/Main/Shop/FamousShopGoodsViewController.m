//
//  FamousShopGoodsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "FamousShopGoodsViewController.h"
#import "GBTagListView.h"
#import "FamousGoodsTableViewCell.h"
#import "HWDownSelectedView.h"
#import "GoodsDetailViewController.h"
@interface FamousShopGoodsViewController () <UITableViewDelegate,UITableViewDataSource,HWDownSelectedViewDelegate>

{
    
    NSString *gradeID;
    NSUInteger selectIndex;
}

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *dataAry;
@property (copy, nonatomic) NSArray *gradeAry;
@property (assign, nonatomic) NSUInteger page;
@property (copy, nonatomic) NSArray *tagAry;
@property (strong, nonatomic) GBTagListView *bubbleView;

@property (strong, nonatomic)  HWDownSelectedView *down1;
@property (weak, nonatomic) IBOutlet UIView *tagBgView;
@property (weak, nonatomic) IBOutlet UIView *selectBgView;

@end

@implementation FamousShopGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _tagID =  @"";
    gradeID = @"";
    [self configNavView];
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configNavView {
    
    _tagBgView.frame = CGRectMake(0, SafeAreaHeight, kWidth, 44);
    _selectBgView.frame = CGRectMake(0, SafeAreaHeight+44, kWidth, 44);
    
    MJWeakSelf
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(0);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    self.titleLab.text = self.name;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+44+44, kWidth, kHeight-(SafeAreaHeight+44+44));
    
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [self getData];
    }];
    
    [_mainTableView.mj_header beginRefreshing];
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _dataAry = [NSMutableArray array];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FamousGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailT"];
    
    if (!cell) {
        
        cell = [FamousGoodsTableViewCell  famousGoodsTableViewCellSearch];
    }
    
    cell.goodsSearch = [AuthorGoods authorGoodsWithDict:self.dataAry[indexPath.row]];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
   
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
  
    return nil;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
   
    return nil;
}

- (void)getData{
    
//    //网络请求
//    NSString *uuid = @"";
//    if ([PublicMethods isLogIn]) {
//        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
//    }
//
//    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
//    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":_ID,@"tag_id":_tagID,@"grade_id":gradeID,@"page":@(_page)}];
    
    [YYNet POST:ShopGoodsDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        NSArray *temp  = @[];
        
        if ([[dic[@"data"]  objectForKey:@"group_list"] isKindOfClass:[NSArray class]]) {
            temp = [dic[@"data"] objectForKey:@"group_list"];
        }
        
        if (self.page == 1) {
            [self.dataAry setArray:temp];
            
        }else{
            [self.dataAry addObjectsFromArray:temp];
            
        }
        
        if (temp.count<20) {
            
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            [self.mainTableView.mj_header endRefreshing];
            
            
        }else{
            
        
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            
        }
        
        if (!self.tagAry.count) {
            
            if ([[dic[@"data"] objectForKey:@"tag_name"] isKindOfClass:[NSArray class]]) {
                
                self.tagAry = [dic[@"data"] objectForKey:@"tag_name"];
                [self.tagBgView addSubview:self.bubbleView];
            }
            
        }
        
        
        
        [self addDownView];
        
        if ([[dic[@"data"] objectForKey:@"author_grade"] isKindOfClass:[NSArray class]]) {
            
            
            self.gradeAry = [dic[@"data"] objectForKey:@"author_grade"];
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.gradeAry) {
                [temp addObject:obj[@"name"]];
            }
        
            self.down1.listArray = temp;
            self.down1.selectedIndex = selectIndex;
        }
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *temp = [_dataAry[indexPath.row] objectForKey:@"id"];
    
    GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
    detailVc.ID = temp;
    detailVc.isGroup = [[_dataAry[indexPath.row] objectForKey:@"is_group"] integerValue];
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

- (void)addDownView{
    
    if (self.down1) {
        return;
    }
    
    HWDownSelectedView *down = [[HWDownSelectedView alloc]initWithFrame:self.selectBgView.bounds];
    down.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:down];
    
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/4);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(self.selectBgView.mas_right).offset(-Space);
        make.top.mas_equalTo(self.selectBgView.mas_top).offset(0);
    }];
    down.delegate = self;
    down.tag = 1;
    self.down1 = down;
    
}

- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath{
    
    gradeID = [self.gradeAry[indexPath.row] objectForKey:@"id"];
    selectIndex = indexPath.row;
    [self.mainTableView.mj_header beginRefreshing];
    
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
                
                weakSelf.tagID = @"";
                [weakSelf.mainTableView.mj_header beginRefreshing];
                return ;
            }
            
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *name in weakSelf.tagAry) {
                
                [temp addObject:name[@"name"]];
                
            }
            
            NSUInteger index = [temp indexOfObject:arr[0]];
            weakSelf.tagID = [weakSelf.tagAry[index] objectForKey:@"id"];
            [weakSelf.mainTableView.mj_header beginRefreshing];
            
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
@end
