//
//  AUthorsListsViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AUthorsListsViewController.h"
#import "HWDownSelectedView.h"
#import "ALLAuthorsTableViewCell.h"
#import "AuthorDetailViewController.h"
#import "AuthorSearchViewController.h"
#import "SearchTagViewController.h"
#import "GoodsDetailViewController.h"

@interface AUthorsListsViewController ()<UITableViewDelegate,UITableViewDataSource,HWDownSelectedViewDelegate>
{
    NSUInteger page;
    NSMutableArray *_dataAry;
    NSString *nearby;
    NSString *grade;
    NSString *sequence;
    NSString *type;
    NSString *filtrate;
    
    NSUInteger nearbyIndex;
    NSUInteger gradeIndex;
    NSUInteger sequenceIndex;
    NSUInteger filtrateIndex;
    
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, strong) YMRefresh *ymRefresh;
@property (weak, nonatomic) IBOutlet UIButton *searchBtnR;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *textBg;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic)  HWDownSelectedView *down1;
@property (strong, nonatomic)  HWDownSelectedView *down2;
@property (strong, nonatomic)  HWDownSelectedView *down3;
@property (strong, nonatomic)  HWDownSelectedView *down4;


@property (strong, nonatomic)  NSMutableDictionary *footerState;

@property (copy, nonatomic)  NSMutableArray *nearbyAry;
@property (copy, nonatomic)  NSMutableArray *intelligentAry;
@property (copy, nonatomic)  NSMutableArray *gradeAry;
@property (copy, nonatomic)  NSMutableArray *filtrateAry;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;


@property (weak, nonatomic) IBOutlet UIView *line1;
@end

@implementation AUthorsListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    page = 1;
    _dataAry = [NSMutableArray array];
    
    _nearbyAry = [NSMutableArray array];
    _gradeAry = [NSMutableArray array];
    _intelligentAry = [NSMutableArray array];
    _filtrateAry = [NSMutableArray array];
    
    _footerState = [NSMutableDictionary dictionary];
    grade = @"";
    sequence = @"";
    nearby = @"";
    filtrate = @"";
    [self configUI];
}

- (void)configUI{
    _titleView.frame = CGRectMake(0, 0, kWidth, 88+SafeAreaTopHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.top.mas_equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
    }];
    
    [_textBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*4-buttonWidth);
        make.height.mas_equalTo(34);
        make.left.mas_equalTo(self.titleView.mas_left).offset(Space+buttonWidth);
        make.top.mas_equalTo(self.titleView.mas_top).offset(SafeAreaTopHeight);
    }];
    _textBg.layer.cornerRadius = 18;
    _textBg.layer.masksToBounds = NO;
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.textBg.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.textBg.mas_centerY).offset(0);
    }];
    
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.searchBtn.mas_right).offset(Space);
        make.centerY.mas_equalTo(self.textBg.mas_centerY).offset(0);
    }];
    
    _searchBtnR.frame = _textBg.bounds;
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.textBg.mas_bottom).offset(10);
    }];
    
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(27);
        make.left.mas_equalTo(self.view.mas_left).offset(kWidth/4);
        make.top.mas_equalTo(self.line.mas_bottom).offset(8);
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(27);
        make.left.mas_equalTo(self.view.mas_left).offset(kWidth/2);
        make.top.mas_equalTo(self.line.mas_bottom).offset(8);
    }];
    
    [_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(27);
        make.left.mas_equalTo(self.view.mas_left).offset(3*kWidth/4);
        make.top.mas_equalTo(self.line.mas_bottom).offset(8);
    }];
    
    
    
    HWDownSelectedView *down = [HWDownSelectedView new];
    down.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:down];
    
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/4-1);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.top.mas_equalTo(self.line.mas_bottom).offset(0);
    }];
    down.delegate = self;
    down.tag = 1;
    self.down1 = down;
    
    HWDownSelectedView *downv = [HWDownSelectedView new];
    downv.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:downv];
    //    down.frame = CGRectMake(kWidth-100-Space, SafeAreaTopHeight-10, 100, 40);
    [downv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/4);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(kWidth/4);
        make.top.mas_equalTo(self.line.mas_bottom).offset(0);
    }];
    downv.delegate = self;
    downv.tag = 2;
    self.down2 = downv;
    
    HWDownSelectedView *downV = [HWDownSelectedView new];
    downV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downV];
    
    [downV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/4);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(kWidth/2);
        make.top.mas_equalTo(self.line.mas_bottom).offset(0);
    }];
    downV.delegate = self;
    downV.tag = 3;
    self.down3 = downV;
    
    HWDownSelectedView *downY = [HWDownSelectedView new];
    downY.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downY];
    
    [downY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth/4);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(3*kWidth/4);
        make.top.mas_equalTo(self.line.mas_bottom).offset(0);
    }];
    downY.delegate = self;
    downY.tag = 4;
    self.down4 = downY;
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaTopHeight+88, kWidth, kHeight-SafeAreaTopHeight-88);
    
    _ymRefresh = [[YMRefresh alloc] init];
    __weak AUthorsListsViewController *weakSelf = self;
    [_ymRefresh gifModelRefresh:_mainTableView refreshType:RefreshTypeDouble firstRefresh:YES timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        self->page = 1;
        [self getData];
        
    } upDropBlock:^{
        
        if ([weakSelf.mainTableView.mj_footer isRefreshing]) {
            self->page++;
            [self getData];
        }
    }];
    
    [self addToolTab];
    //    [self.mainTableView.mj_header beginRefreshing];
    
    //     [self.view insertSubview:self.line1 belowSubview:self.down1];
    
    
    
    
    
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
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"lat":lat,@"lng":lng,@"page":@(page),@"grade":grade,@"nearby":nearby,@"sequence":sequence,@"content":_searchTF.text,@"city_id":city_id,@"filtrate":filtrate}];
    
    [YYNet POST:MineAuthorLIST paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if (![[dic[@"data"] objectForKey:@"author_list"] isKindOfClass:[NSArray class]]) {
            [self->_mainTableView.mj_header endRefreshing];
            [self->_mainTableView.mj_footer endRefreshing];
            return ;
        }
        
        NSArray *temp = [[dic objectForKey:@"data"] objectForKey:@"author_list"];
        
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
        
       
        if ([[dic[@"data"] objectForKey:@"nearby"] isKindOfClass:[NSArray class]]) {
            
            [self.nearbyAry setArray:[dic[@"data"] objectForKey:@"nearby"]];
            
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.nearbyAry) {
                [temp addObject:obj[@"name"]];
            }
            
            [temp insertObject:@"附近" atIndex:0];
            self.down1.selectedIndex = self->nearbyIndex;
            self.down1.listArray = temp;
            
        }
        
        if ([[dic[@"data"] objectForKey:@"author_grade"] isKindOfClass:[NSArray class]]) {
            
            [self.gradeAry setArray:[dic[@"data"] objectForKey:@"author_grade"]];
            
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.gradeAry) {
                [temp addObject:obj[@"name"]];
            }
            [temp insertObject:@"匠人级别" atIndex:0];
            self.down2.selectedIndex = self->gradeIndex;
            self.down2.listArray = temp;
        }
        
        if ([[dic[@"data"] objectForKey:@"intelligent"] isKindOfClass:[NSArray class]]) {
            
            [self.intelligentAry setArray:[dic[@"data"] objectForKey:@"intelligent"]];
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.intelligentAry) {
                [temp addObject:obj[@"name"]];
            }
            
            self.down3.selectedIndex = self->sequenceIndex;
            self.down3.listArray = temp;
            
        }
        
        if ([[dic[@"data"] objectForKey:@"filtrate"] isKindOfClass:[NSArray class]]) {
            
            [self.filtrateAry setArray:[dic[@"data"] objectForKey:@"filtrate"]];
            
            NSMutableArray *temp = [NSMutableArray array];
            
            for (NSDictionary *obj in self.filtrateAry) {
                [temp addObject:obj[@"name"]];
            }
            
            [temp insertObject:@"筛选" atIndex:0];
            
            self.down4.selectedIndex = self->filtrateIndex;
            self.down4.listArray = temp;
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    ShopAuthor *author = [ShopAuthor shopAuthorWithDict:_dataAry[section]];
    
    BOOL isExpand = [[_footerState objectForKey:@(section)] boolValue];
    
    if (isExpand || author.author_goods.count<=3) {
        return author.author_goods.count +1;
    }
    
    if (author.author_goods.count >3 && !isExpand) {
        
        return 4;
    }
    
    
    
    return 1;
    
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
        
        ALLAuthorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        if (cell == nil) {
            cell = [ALLAuthorsTableViewCell allAuthorsTableViewCellSecond];
        }
        
        ShopAuthor *author = [ShopAuthor shopAuthorWithDict:_dataAry[indexPath.section]];
        cell.goods = [AuthorGoods authorGoodsWithDict:author.author_goods[indexPath.row-1]];
        return cell;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 ) {
        
        return 88;
        
    }
    
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NSArray *temp = [_dataAry[section] objectForKey:@"author_goods"];
    
    if (temp.count > 3) {
        return 32;
    }
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSArray *temp = [_dataAry[section] objectForKey:@"author_goods"];
    
    if (temp.count > 3) {
        
        UIButton *btn = [[UIButton alloc]init];
        switch ([_footerState[@(section)] integerValue]) {
                //                收起
            case 1:
            {
                [btn setTitle:[NSString stringWithFormat:@"收起"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"向下红"] forState:UIControlStateNormal];
            }
                
                break;
                //                更多
            case 0:
            {
                [btn setTitle:[NSString stringWithFormat:@"查看其它%lu个微美惠会员价格",(unsigned long)temp.count] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"向下红"] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        
        
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:2];
        [btn setTitleColor:MainColor forState:UIControlStateNormal];
        btn.tag = section;
        [btn addTarget:self action:@selector(lookMore:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        btn.backgroundColor = [UIColor whiteColor];
        return btn;
        
    }
    
    return nil;
    
}

- (void)lookMore:(UIButton *)sender{
    
    
    if ([[_footerState objectForKey:@(sender.tag)] boolValue]) {
        
        [_footerState setObject:@"0" forKey:@(sender.tag)];
        
    }else{
        
        [_footerState setObject:@"1" forKey:@(sender.tag)];
        
    }
    
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
    
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

//头像
- (void)didClickIconIndex:(NSInteger)index{
    NSString *uuid = [_dataAry[index] objectForKey:@"uuid"];
    AuthorDetailViewController *detailVc = [[AuthorDetailViewController alloc]init];
    detailVc.ID = uuid;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - 下拉列表
- (void)downSelectedView:(HWDownSelectedView *)selectedView didSelectedAtIndex:(NSIndexPath *)indexPath {
    
    //    附近
    if (selectedView.tag == 1) {
        
        if (indexPath.row == 0) {
            
            nearby = @"";
            
        }else{
            
            nearby =  [self.nearbyAry[indexPath.row - 1] objectForKey:@"id"];
            
        }
        
        nearbyIndex = indexPath.row;
    }
    
    //    手艺人
    if (selectedView.tag == 2) {
        
        if (indexPath.row == 0) {
            
            grade = @"";
            
        }else{
            
            grade =  [self.gradeAry[indexPath.row - 1] objectForKey:@"id"];;
            
        }
        gradeIndex = indexPath.row;
    }
    
    //  智能排序
    if (selectedView.tag == 3) {
        
        
        sequence =  [self.intelligentAry[indexPath.row] objectForKey:@"id"];
        sequenceIndex = indexPath.row;
        
    }
    
    //  筛选
    if (selectedView.tag == 4) {
        
        if (indexPath.row == 0) {
            
            filtrate = @"";
            
        }else{
            
            filtrate = [self.filtrateAry[indexPath.row - 1] objectForKey:@"id"];
            
        }
        
        filtrateIndex = indexPath.row;
    }
    
    page = 1;
    [self.mainTableView.mj_header beginRefreshing];
    
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchAction:(UIButton *)sender {
    
    SearchTagViewController *tagVC= [[SearchTagViewController alloc]init];
    tagVC.type = 2;
    [self.navigationController pushViewController:tagVC animated:YES];
    
    //    AuthorSearchViewController *searchVC = [[AuthorSearchViewController alloc]init];
    //    searchVC.content = _searchTF.text;
    //    [self.navigationController pushViewController:searchVC animated:YES];
    //    _searchTF.text = @"";
    //    [_searchTF resignFirstResponder];
}

- (void)addToolTab{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    //        [topView setBarStyle:UIBarStyleBlackTranslucent];//设置增加控件的基本样式，UIBarStyleDefault为默认样式。
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(doneWithIt) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"确定" forState:(UIControlStateNormal)];
    btn.backgroundColor = MainColor;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [self.searchTF setInputAccessoryView:topView];
    
}

- (void)doneWithIt{
    
    [self.view endEditing:YES];
    
    if (!_searchTF.text.length) {
        return;
    }
    
    AuthorSearchViewController *searchVC = [[AuthorSearchViewController alloc]init];
    searchVC.content = _searchTF.text;
    [self.navigationController pushViewController:searchVC animated:YES];
    _searchTF.text = @"";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}


@end


