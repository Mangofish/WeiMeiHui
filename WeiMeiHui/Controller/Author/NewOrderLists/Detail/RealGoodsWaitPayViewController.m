//
//  RealGoodsWaitPayViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/11/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "RealGoodsWaitPayViewController.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "AlertView.h"
#import "ErCodeOrderTableViewCell.h"
#import "ThreeTypeOrderTableViewCell.h"
#import "AuthorDetailViewController.h"
#import "GoodsDetailViewController.h"

@interface RealGoodsWaitPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (copy,nonatomic) NSDictionary *dataDic;

@end

@implementation RealGoodsWaitPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavView];
    [self getData];
    
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

    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
  
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (!self.dataDic) {
        return 0;
    }
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section == 2) {
        return 190;
    }
    
    if (indexPath.section == 0) {
        
        return 60;
        
    }
    
    if (indexPath.section >= 3) {
        
        if (indexPath.row == 0 ) {
            
            return 88;
            
        }
        
        return 49;
        
    }
    
    return 60;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 3) {
        return 44;
    }
    
    
    return 0.00001;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
   
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    订单状态
    if (indexPath.section == 0) {
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        
        cell.order = [GoodsDetail authorGoodsWithDict:self.dataDic];
        
        cell.status.text = @"待使用";
        
        return cell;
        
    }else if (indexPath.section == 1) {
        
        //        参数不一样
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        
        cell.realorder = [GoodsDetail authorGoodsWithDict:self.dataDic];
        
        return cell;
        
    }else {
        
        ErCodeOrderTableViewCell *cell = [ErCodeOrderTableViewCell erCodeOrderTableViewCellEasy];
        if (self.dataDic) {
            cell.goodsDetailEasy = [ThreeOrder recentOrderWithDict:self.dataDic];
        }
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
//
//            NSArray *temp = [self.authorDataAry[indexPath.section-3] objectForKey:@"author_goods"];
//
//            NSString *uuid = [temp[indexPath.row-1] objectForKey:@"id"];
//            GoodsDetailViewController *detailVc = [[GoodsDetailViewController alloc]init];
//            detailVc.ID = uuid;
//            detailVc.isGroup = [[temp[indexPath.row-1] objectForKey:@"is_group"] integerValue];
//            [self.navigationController pushViewController:detailVc animated:YES];
    
    
    
}


- (void)getData{
    
    
//    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
//    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    
     NSString *url = [PublicMethods dataTojsonString:@{@"order_number":_ID}];
    
    [YYNet POST:RealOrderDetail paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.dataDic = dic[@"data"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mainTableView reloadData];
        });
        
        
    } faild:^(id responseObject) {
        
    }];
    
}




#pragma mark -联系客服
- (IBAction)telAction:(UIButton *)sender {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",_dataDic[@"tel"]]]]];
    [self.view addSubview:callWebview];
    
}

@end
