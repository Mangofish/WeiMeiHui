//
//  GroupPayOutdateViewController.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GroupPayOutdateViewController.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "JoinGroupTableViewCell.h"
#import "GroupPayViewController.h"

@interface GroupPayOutdateViewController ()<UITableViewDelegate, UITableViewDataSource,JoinGroupTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@property (copy, nonatomic)  NSDictionary *orderDataDic;

@end

@implementation GroupPayOutdateViewController

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
    
    [_telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);

    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.orderDataDic) {
        return 0;
    }
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
    
        return 3;
    }
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
//            if ([self.type integerValue] == 4) {
//                return 40;
//            }
            
            return 60;
        }
        
        if (indexPath.row == 1) {
            return 88;
        }
        
        return 44;
    }
    
    if (indexPath.section == 2) {
        
        return 216;
        
    }
    
    if (indexPath.section == 0) {
        
        return 60;
        
    }
    
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.00001;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOrder];
        
        cell.order = [GoodsDetail authorGoodsWithDict:self.orderDataDic];
        cell.status.text = @"未拼成";
        return cell;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFour];
            cell.goodsDetail = [GoodsDetail authorGoodsWithDict:self.orderDataDic];
            return cell;
        }
        
        if (indexPath.row == 1) {
            ALLAuthorsTableViewCell *cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            cell.author = [ShopAuthor shopAuthorWithDict:self.orderDataDic];
            return cell;
        }
            
        if (indexPath.row == 2) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                return cell;
            }
    }
    
    JoinGroupTableViewCell *cell = [JoinGroupTableViewCell joinGroupTableViewCell];
    if (self.orderDataDic) {
        cell.goodFailDetail = [GoodsDetail authorGoodsWithDict:self.orderDataDic];
    }
    cell.delegate = self;
    return cell;
    
}

- (void)getData{
    
    //网络请求
    //    NSString *uuid = @"";
    //    if ([PublicMethods isLogIn]) {
    //        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    //    }

    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:GroupOrderDetails paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self.orderDataDic = dic[@"data"];
        [self.mainTableView reloadData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [self configNavView];
//
//        });
    } faild:^(id responseObject) {
        
    }];
    
}

- (IBAction)serviceAction:(UIButton *)sender {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://%@",self.orderDataDic[@"tel"]]]]];
    [self.view addSubview:callWebview];
    
}

#pragma  mark - 去重新拼团
- (void)didSelectJoinGroup{
    
    GroupPayViewController *groupVC = [[GroupPayViewController alloc]init];
    groupVC.ID = self.orderDataDic[@"goods_id"];
    [self.navigationController pushViewController:groupVC animated:YES];
    
}


@end
