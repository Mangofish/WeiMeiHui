//
//  AllShopViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AllShopViewController.h"
#import "ChooseShopTableViewCell.h"

@interface AllShopViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataAry;
    NSUInteger page;
}


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation AllShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    [self getData];
    
    [self configNavView];
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configNavView {
    
    dataAry = [NSMutableArray array];
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
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight + Space, kWidth, kHeight-Space- SafeAreaHeight);
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.rowHeight = 60;
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page = 1;
        [self getData];
    }];
    _mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self->page++;
        [self getData];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataAry.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.row == 0) {
        
       UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.textLabel.text = dataAry[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = FontColor;
         return cell;
        
    }else{
        
        ChooseShopTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell) {
            cell = [[ChooseShopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        ChooseShops *shop = [ChooseShops shopListWithDict:dataAry[indexPath.row]];
        
        if ([shop.shop_id isEqualToString:self.alredyShopID]) {
            
        }
        
        cell.shop = shop;
        return cell;
    }
    
    
   
}


- (void)getData{
    
    //网络请求
    
//    获取经纬度
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"lat":lat,@"lng":lng,@"page":@(page)}];
    
    
    [YYNet POST:ChooseSHOP paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        NSArray *temp;
        if ([dic[@"data"] isKindOfClass:[NSArray class]]) {
            temp = dic[@"data"];
        }
        
        if (page == 1) {
            
            [dataAry setArray:temp];
            [dataAry insertObject:@"不显示位置" atIndex:0];
            
        }else{
            [dataAry addObjectsFromArray:temp];
            
        }
        
        [self.mainTableView reloadData];
        
        [_mainTableView.mj_footer endRefreshing];
        [_mainTableView.mj_header endRefreshing];
       
        
    } faild:^(id responseObject) {
         
        MJWeakSelf
        self.mainTableView.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:@"暂时没有网络" titleStr:@"" detailStr:@"" btnTitleStr:@"重新加载" btnClickBlock:^{
            [weakSelf getData];
        }];
        
        
    }];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        self.selectComplete(@"", @"不显示位置");
    }else{
        self.selectComplete([dataAry[indexPath.row] objectForKey:@"shop_id"], [dataAry[indexPath.row] objectForKey:@"shop_name"]);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
