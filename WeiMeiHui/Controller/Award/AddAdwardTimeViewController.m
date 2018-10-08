//
//  AddAdwardTimeViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AddAdwardTimeViewController.h"
#import "PickAwardsTableViewCell.h"
#import "GroupGoodsListsViewController.h"
#import "NextFreeNewViewController.h"
#import "AUthorsListsViewController.h"

@interface AddAdwardTimeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableDictionary *heightDic;
    
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (copy, nonatomic)  NSDictionary *orderData;



@end

@implementation AddAdwardTimeViewController

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
    
    
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
    _mainTableView.rowHeight = 49;
    //    _orderDataAry = [NSMutableArray array];
    heightDic = [NSMutableDictionary dictionary];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PickAwardsTableViewCell *cell = [PickAwardsTableViewCell activityThreeTableViewCellChance];
    
    if (indexPath.section == 0) {
        
        cell.titleChance.text = @"每日关注5名手艺人";
        
        if ([self.orderData[@"relationship_status"] integerValue] == 1) {
            [cell.chanceBtn setTitle:@"已完成" forState:UIControlStateNormal];
            [cell.chanceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            cell.chanceBtn.backgroundColor = [UIColor whiteColor];
            cell.chanceBtn.frame = CGRectMake(kWidth-70, 10, 60, 25);
            
            cell.chanceBtn.layer.borderWidth = 1;
            cell.chanceBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            
        }else{
            
            if (self.orderData) {
                [cell.chanceBtn setTitle:[NSString stringWithFormat:@"%@/5  去完成",self.orderData[@"relationship_num"]] forState:UIControlStateNormal];
            }
            
            [cell.chanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.chanceBtn.backgroundColor = MainColor;
            cell.chanceBtn.frame = CGRectMake(kWidth-90, 10, 80, 25);
        }
        
       
    }
   
    if (indexPath.section == 1) {
        
        cell.titleChance.text = @"每日参与1次拼团";
        
        if ([self.orderData[@"group_status"] integerValue] == 1) {
            [cell.chanceBtn setTitle:@"已完成" forState:UIControlStateNormal];
            [cell.chanceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            cell.chanceBtn.backgroundColor = [UIColor whiteColor];
            
            cell.chanceBtn.layer.borderWidth = 1;
            cell.chanceBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            
        }else{
            [cell.chanceBtn setTitle: @"去完成" forState:UIControlStateNormal];
            [cell.chanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.chanceBtn.backgroundColor = MainColor;
            
        }
        
       cell.chanceBtn.frame = CGRectMake(kWidth-70, 10, 60, 25);
        
    }
    
    if (indexPath.section == 2) {
        
        cell.titleChance.text = @"邀请好友";
        
        if ([self.orderData[@"invite_status"] integerValue] == 1) {
            [cell.chanceBtn setTitle:@"已完成" forState:UIControlStateNormal];
            [cell.chanceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            cell.chanceBtn.backgroundColor = [UIColor whiteColor];
            
            
            cell.chanceBtn.layer.borderWidth = 1;
            cell.chanceBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            
        }else{
            [cell.chanceBtn setTitle: @"去完成" forState:UIControlStateNormal];
            [cell.chanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.chanceBtn.backgroundColor = MainColor;
        }
        
        cell.chanceBtn.frame = CGRectMake(kWidth-70, 10, 60, 25);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.0001;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return Space;
    
}

- (void)getData{
    
    //网络请求
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    //    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    //    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid}];
    
    [YYNet POST:AddLotteryList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self.orderData = dic[@"data"];
        [self.mainTableView.mj_header  endRefreshing];
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    手艺人列表
    if (indexPath.section == 0) {
        
        AUthorsListsViewController *listVC = [[AUthorsListsViewController alloc]init];
        [self.navigationController pushViewController:listVC animated:YES];
        
    }
    
    //    拼团列表
    if (indexPath.section == 1) {
        
        GroupGoodsListsViewController *listVC = [[GroupGoodsListsViewController alloc]init];
        [self.navigationController pushViewController:listVC animated:YES];
        
    }
    
    
    //    邀请好友
    if (indexPath.section == 2) {
        
        NextFreeNewViewController *adVC = [[NextFreeNewViewController alloc]init];
        
        NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
        NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
        NSString* uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        NSString *finalUrl = [NSString stringWithFormat:@"http://try.wmh1181.com/index.php?s=/AppActivity/Activity/invite/uuid/%@/lat/%@/lng/%@",uuid,lat,lng];
        
        adVC.url = finalUrl;
        [self.navigationController pushViewController:adVC animated:YES];
        
    }
    
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getData];
    
    
}

@end
