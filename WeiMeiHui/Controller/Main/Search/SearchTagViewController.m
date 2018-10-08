//
//  SearchTagViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SearchTagViewController.h"
#import "SearchResultsViewController.h"
#import "HotSerachCell.h"
#import "AuthorSearchResultViewController.h"

@interface SearchTagViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DWQTagViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIView *textBgView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchImg;

@property (nonatomic,strong) UITableView *tableview;

/** 历史搜索数组 */
@property (nonatomic, strong) NSMutableArray *historyArr;
/** 热门搜索数组 */
@property (nonatomic, strong) NSMutableArray *HotArr;
/** 得到热门搜索TagView的高度 */
@property (nonatomic ,assign) CGFloat tagViewHeight;
@property (nonatomic, weak) UIButton *emptyButton;



@end

@implementation SearchTagViewController

-(instancetype)init
{
    if (self = [super init]) {
        self.historyArr = [NSMutableArray array];
        self.HotArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    self.searchTF.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEIHISTORY]) {
        NSArray *his = [[NSUserDefaults standardUserDefaults] valueForKey:WEIHISTORY];
         [_historyArr setArray:his];
    }
    
   
    
    [self configNavView];
    [self getData];
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    [_textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*4-48-buttonWidth);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.backBtn.mas_right).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    _textBgView.layer.cornerRadius = 24;
    _textBgView.layer.masksToBounds = YES;
    
    [_searchImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textBgView.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.textBgView.mas_centerY).offset(0);
    }];
    
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*5-buttonWidth*3);
        make.height.mas_equalTo(buttonHeight);
        make.left.mas_equalTo(self.searchImg.mas_right).offset(Space);
        make.top.mas_equalTo(self.textBgView.mas_top).offset(0);
    }];
    [self.view addSubview:self.tableview];
}

#pragma mark -- 懒加载
-(UITableView *)tableview
{
    if (!_tableview) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaHeight+Space, kWidth, kHeight-SafeAreaHeight-Space) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerClass:[HotSerachCell class] forCellReuseIdentifier:@"HotCellID"];
        _tableview.backgroundColor = [UIColor colorWithWhite:0.934 alpha:1.000];
    }
    return _tableview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
/** section的数量 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.historyArr.count == 0) {
        return 1;
    }
    else
    {
        return 2;
    }
}

/** CELL */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        HotSerachCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"HotCellID" forIndexPath:indexPath];
        hotCell.dwqTagV.delegate = self;
        hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
        hotCell.userInteractionEnabled = YES;
        hotCell.hotSearchArr = self.HotArr;
        /** 将通过数组计算出的tagV的高度存储 */
        self.tagViewHeight = hotCell.dwqTagV.frame.size.height;
        return hotCell;
        
    }else{
        
        HotSerachCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"HotCellID" forIndexPath:indexPath];
        hotCell.dwqTagV.delegate = self;
        hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
        hotCell.userInteractionEnabled = YES;
        hotCell.hotSearchArr = self.historyArr;
        /** 将通过数组计算出的tagV的高度存储 */
        self.tagViewHeight = hotCell.dwqTagV.frame.size.height;
        return hotCell;
        
    }
    

    
}
/** HeaderView */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    headView.backgroundColor = [UIColor whiteColor];
    for (UILabel *lab in headView.subviews) {
        [lab removeFromSuperview];
    }
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 10, 35)];
    titleLab.textColor = [UIColor colorWithWhite:0.229 alpha:1.000];
    titleLab.font = [UIFont systemFontOfSize:14];
    [headView addSubview:titleLab];
    if (self.historyArr.count == 0) {
        titleLab.text = @"热门搜索";
    }
    else
    {
        if (section == 0) {
            titleLab.text = @"热门搜索";
        }
        else
        {
            titleLab.text = @"历史记录";
            
        }
    }
    return headView;
}
/** FooterView */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.1)];
        return view;
}
/** 头部的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
/** cell的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tagViewHeight + 40;
}
/** FooterView的高 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Space;
}


#pragma mark -- 实现点击热门搜索tag  Delegate
-(void)DWQTagView:(UIView *)dwq fetchWordToTextFiled:(NSString *)KeyWord
{
    NSLog(@"点击了%@",KeyWord);
    
//    存
    
    _searchTF.text = KeyWord;
    
    
    
    if ([_historyArr containsObject:KeyWord]) {
        
        [_historyArr removeObject:KeyWord];
        [_historyArr insertObject:KeyWord atIndex:0];
        
    }else if(_historyArr.count < 12){
        
        [_historyArr addObject:KeyWord];
        
    }else{
        
        [_historyArr replaceObjectAtIndex:0 withObject:KeyWord];
        
    }
    
    [self resultAction];
    
    
    
}
- (void)getData{
    
//    NSString *url = [PublicMethods dataTojsonString:@{@"type":@(_type)}];
    
    [YYNet POST:SearchHot paramters:@{@"json":@""} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        NSArray *temp = [dic objectForKey:@"data"];
        for (NSDictionary *obj in temp) {
            [self.HotArr addObject:obj[@"content"]];
        }
        
        [self.tableview reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}


- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark- 取消
- (IBAction)searchAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
  
    
}

- (void)resultAction{
    
    if (_searchTF.text.length == 0) {
        return;
    }
    
    NSString *str = _searchTF.text;
    
    if ([_historyArr containsObject:str]) {
        
        [_historyArr removeObject:str];
        [_historyArr insertObject:str atIndex:0];
        
    }else if(_historyArr.count < 12){
        
        [_historyArr addObject:str];
        
    }else{
        
        [_historyArr replaceObjectAtIndex:0 withObject:str];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:_historyArr forKey:WEIHISTORY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    跳页
    
    if (_type == 1) {
        
        SearchResultsViewController *reVC = [[SearchResultsViewController alloc]init];
        reVC.content = _searchTF.text;
        [self.navigationController pushViewController:reVC animated:YES];
        
    }else{
        
        AuthorSearchResultViewController *searchVC = [[AuthorSearchResultViewController alloc]init];
        searchVC.content = _searchTF.text;
        [self.navigationController pushViewController:searchVC animated:YES];
        
    }
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self resultAction];
    return YES;
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tableview reloadData];
    [self.searchTF becomeFirstResponder];
}

@end
