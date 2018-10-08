//
//  InviteFriendsListViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "InviteFriendsListViewController.h"
#import "PickAwardsTableViewCell.h"
#import "NextFreeNewViewController.h"

@interface InviteFriendsListViewController ()<UITableViewDelegate, UITableViewDataSource,PickAwardsTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (copy, nonatomic)  NSArray *orderData;
@property (copy, nonatomic)  NSArray *inviteData;



@end

@implementation InviteFriendsListViewController

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
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1-40);
    _mainTableView.rowHeight = 49;
    
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.orderData.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 160;
    }else{
        return 49;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        PickAwardsTableViewCell *cell = [PickAwardsTableViewCell activityThreeTableViewCellPick];
        cell.dataAry = self.inviteData;
        cell.delegate = self;
        return cell;
        
    }else{
        
        PickAwardsTableViewCell *cell = [PickAwardsTableViewCell activityThreeTableViewCellFriend];
        cell.friendsDic = self.orderData[indexPath.section-1];
        return cell;
        
    }
    
    
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
    
    [YYNet POST:InviteList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        self.inviteData = [dic[@"data"] objectForKey:@"invite_award"];
        self.orderData = [dic[@"data"] objectForKey:@"invite_list"];
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}

#pragma mark -领取
- (void)takeAwards:(NSString *)couponID{
    
    NSString *uuid = @"";
    if ([PublicMethods isLogIn]) {
        uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    

    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"coupon_id":couponID}];
    
    [YYNet POST:GetInviteCoupon paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            [self getData];
        }
        
    } faild:^(id responseObject) {
        
    }];
    
}


- (IBAction)pickAction:(UIButton *)sender {
    
    NextFreeNewViewController *adVC = [[NextFreeNewViewController alloc]init];
    
    adVC.url = @"http://try.wmh1181.com/index.php?s=/AppActivity/Activity/invite";
    [self.navigationController pushViewController:adVC animated:YES];
    
}
@end
