
//
//  WeiJoinGroupViewController.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiJoinGroupViewController.h"
#import "GoodsDetailSmallTableViewCell.h"
#import "GroupPayPageTableViewCell.h"
#import "JoinGroupTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "GoodsGroupTableViewCell.h"
#import "JoinSingleGroupViewController.h"

#import "NextFreeNewViewController.h"

@interface WeiJoinGroupViewController ()<UITableViewDelegate,UITableViewDataSource,JoinGroupTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (copy, nonatomic) NSDictionary *dataDic;

@end

@implementation WeiJoinGroupViewController

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
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.rowHeight = 44;
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight);
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }
    
    if (section == 3) {
        return 2;
    }
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    发起人
    if (indexPath.section == 0) {
        
        GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFive];
        cell.goodsDetail = [GoodsDetail authorGoodsWithDict:_dataDic];
        return cell;
        
//        商品名
    }else if (indexPath.section == 1 ){
        
        if (indexPath.row == 0) {
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFour];
            cell.goodsDetail = [GoodsDetail authorGoodsWithDict:_dataDic];
            return cell;
            
            
        }else if (indexPath.row == 1){
            
//            手艺人
            ALLAuthorsTableViewCell *cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            
            cell.author = [ShopAuthor shopAuthorWithDict:_dataDic];
            return cell;
            
        }else{
            
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
            return cell;
            
        }
        
        
    }else if (indexPath.section == 2){
        
//        参团情况
        JoinGroupTableViewCell *cell = [JoinGroupTableViewCell joinGroupTableViewCell];
        
        if (_dataDic) {
            cell.goodsDetail = [GoodsDetail authorGoodsWithDict:_dataDic];
        }
        cell.delegate = self;
        
        return cell;
        
    }else{
        
        if (indexPath.row == 0) {
            GoodsGroupTableViewCell *cell = [GoodsGroupTableViewCell goodsGroupTableViewCellTwo];
            return cell;
        }else{
            GoodsGroupTableViewCell *cell = [GoodsGroupTableViewCell goodsGroupTableViewCellThree];
            return cell;
        }
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 60;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 60;
        }
        
        if (indexPath.row == 1) {
            return 88;
        }
    }
    
    if (indexPath.section == 2) {
        return 186;
    }
    
    if (indexPath.section == 3) {
        
        if (indexPath.row == 1) {
            return 49;
        }
    }
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Space;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.000001;
    
}

- (void)getData{
    
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"common_order_num":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:GoodsOffered paramters:@{@"json":url} success:^(id responseObject) {
        
          NSDictionary *dic = [solveJsonData changeType:responseObject];
        self.dataDic = dic[@"data"];
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    拼团规则
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
            NextFreeNewViewController *adVC = [[NextFreeNewViewController alloc]init];
            adVC.url = self.dataDic[@"group_rule_url"];
            [self.navigationController pushViewController:adVC animated:YES];
            
        }
    }
    
}

- (void)didSelectJoinGroup{
    
    JoinSingleGroupViewController *weiVC = [[JoinSingleGroupViewController alloc]init];
    weiVC.ID = self.ID;
    weiVC.goodsID = self.goodsID;
    [self.navigationController pushViewController:weiVC animated:YES];
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
