//
//  AuthorMineViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorMineViewController.h"
#import "WeiUserInfo.h"
#import "MineHeaderView.h"
#import "AuthorDetailHead.h"

#import "CommentOrderTableViewCell.h"

#import "MineFirstTableViewCell.h"

#import "MyOrderListViewController.h"
#import "MyCommentListViewController.h"
#import "MyFollowListViewController.h"
#import "MyPulishedWorkViewController.h"
#import "ChangeUserDataViewController.h"
#import "LoginViewController.h"
#import "MySettingViewController.h"
#import "MainAuthorsOrderListViewController.h"
#import "MineConversationListViewController.h"
#import "SystemNotifyViewController.h"
#import "QRCodeViewController.h"
#import "OrderTwoTableViewCell.h"

#import "AuthorsAllOrderListViewController.h"
#import "RecentOrderListsViewController.h"

@interface AuthorMineViewController ()<UITableViewDelegate,UITableViewDataSource,MineHeaderViewDelegate>{
    WeiUserInfo *user;
    NSUInteger page;
    NSMutableDictionary *heightDic;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *saoBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableArray *dataAry;
@property (strong, nonatomic)  AuthorDetailHead *head ;

@end

@implementation AuthorMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.hidden = YES;
    _dataAry = [NSMutableArray array];
    heightDic = [NSMutableDictionary dictionary];
    page = 1;
    [self configNavView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self getData];
    
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_settingsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.mas_equalTo(24);
        //        make.height.mas_equalTo(24);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-Space);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.settingsBtn.mas_centerY);
    }];
    
    [_saoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.mas_equalTo(24);
        //        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.settingsBtn.mas_centerY);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight-48);
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
//    订单（0）
    
    if (indexPath.section == 1) {
        
        OrderTwoTableViewCell *cell = [OrderTwoTableViewCell orderTwoTableViewCell];
    
        if (user) {
            cell.cusOrderNum.text = [NSString stringWithFormat:@"%@",user.custom_num];
            cell.normalOrderNum.text = [NSString stringWithFormat:@"%@",user.group_num];
        }
        
        
        return cell;
    }
    
    MineFirstTableViewCell *cell = [MineFirstTableViewCell mineFirstTableViewCell];
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.titleL.text = @"我发布的作品";
            cell.count.text = user.send_count;
            cell.count.hidden = NO;
        }
        
        if (indexPath.row == 1) {
            cell.titleL.text = @"我收藏的作品";
            cell.count.text = user.collect_count;
            cell.count.hidden = NO;
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.titleL.text = @"我参与的活动";
            cell.count.hidden = YES;
        }
    }
    
    if (indexPath.section == 4) {
        CommentOrderTableViewCell *cell = [CommentOrderTableViewCell commentOrderTableViewCellWithPic];
        
        if (self.dataAry.count) {
            cell.comment = [OrderComment orderCommentWithDict:self.dataAry[indexPath.row]];
        }
        
        
        heightDic[@(indexPath.row)] = @(cell.cellHeight);
        cell.separatorInset = UIEdgeInsetsMake(45, 0, 0, 0);
        return cell;
    }
    
   
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (section == 0 || section == 3) {
        return 0;
    }
    
    if (section == 1 ) {
        return 1;
    }
    
    if (section == 4) {
        return self.dataAry.count;
    }
    
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        return 60;
    }
    
    if (indexPath.section == 4) {
        return [heightDic[@(indexPath.row)] doubleValue];
    }
    
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
//    if (section == 3) {
//        return Space;
//    }
    
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        MineHeaderView *v = [MineHeaderView headerViewWithFrame:CGRectMake(0, 0, kWidth, 240)];
        v.messageBtn.selected = YES;
        v.infoBtn.selected = YES;
        v.followBtn.selected = YES;
        if (user) {
            v.user = user;
        }
        v.delegate = self;
        return v;
    }
    
    if (section == 4) {
        return self.head;
    }
    
    return nil;
}

- (AuthorDetailHead *)head{
    
    if (!_head) {
        
        _head = [AuthorDetailHead authorDetailHeadMine];
        
    }
    return _head;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 240;
    }
    
    if (section == 4) {
        return [heightDic[@"head"] doubleValue];
    }
    
    return Space;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![PublicMethods isLogIn]) {
        LoginViewController *userVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:userVC animated:YES];
        return;
    }
    
//订单
    if (indexPath.section == 1) {
        AuthorsAllOrderListViewController *userVC = [[AuthorsAllOrderListViewController alloc]init];
        [self.navigationController pushViewController:userVC animated:YES];
    }
    
//    参与的活动
    if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
//            MyCouponsViewController *orderVC = [[MyCouponsViewController alloc]init];
//            [self.navigationController pushViewController:orderVC animated:YES];
        }
        
        
    }
    
    
//    if (indexPath.section == 2) {
//
//        if ([user.level integerValue] == 3) {
//
//            RecentOrderListsViewController *orderVC = [[RecentOrderListsViewController alloc]init];
//            [self.navigationController pushViewController:orderVC animated:YES];
//
//        }else{
//
//            MainAuthorsOrderListViewController *orderVC = [[MainAuthorsOrderListViewController alloc]init];
//            [self.navigationController pushViewController:orderVC animated:YES];
//
//        }
//
//
//    }
    
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            MyPulishedWorkViewController *orderVC = [[MyPulishedWorkViewController alloc]init];
            orderVC.type = 1;
            [self.navigationController pushViewController:orderVC animated:YES];
        }else{
            MyPulishedWorkViewController *orderVC = [[MyPulishedWorkViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        
        
    }
    
}

- (void)getData{
    
    
    if (![PublicMethods isLogIn]) {
        NSDictionary *dic = @{ @"fans_count" : @"",
                               @"image" : @"",
                               @"personal_sign" : @"",
                               @"nickname" : @"登录",@"send_count" : @""};
        user = [WeiUserInfo weiUserInfoWithDict:dic];
        [self.mainTableView reloadData];
        return;
    }
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];;
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"page":@(page)}];
    
    [YYNet POST:MINE paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        [[NSUserDefaults standardUserDefaults] setValue:dict[@"data"] forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self->user = [WeiUserInfo weiUserInfoWithDict:dict[@"data"]];
        self.dataAry = [dict[@"data"] objectForKey:@"evaluate_list"];
        
        
        
        self.head.model = [ShopModel shopModeltWithDict:dict[@"data"]];
        self.head.tagAry = [dict[@"data"] objectForKey:@"service_tag"];
        self.head.frame = CGRectMake(0, 0, kWidth, self.head.cellHeight);
        self->heightDic[@"head"] = @(self.head.cellHeight);
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
        
    }];
}


#pragma mark- 头部代理
//四个选项
-(void)didClickMenuIndex:(NSInteger)index{
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *userVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:userVC animated:YES];
        return;
    }
    //    评论
    if (index == 1) {
        
        MyCommentListViewController *myVC = [[MyCommentListViewController alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
        
    }
    
    //    粉丝
    if (index == 2) {
        
        MyFollowListViewController *myVC = [[MyFollowListViewController alloc]init];
        myVC.type = 1;
        [self.navigationController pushViewController:myVC animated:YES];
        
    }
    
    //    通知
    if (index == 4) {
        
        SystemNotifyViewController *myVC = [[SystemNotifyViewController alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
        
    }
    
    //    关注
    if (index == 3) {
        MyFollowListViewController *myVC = [[MyFollowListViewController alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
    }
    
}

//修改资料
- (void)didClickIconBtn{
    
    if ([PublicMethods isLogIn]) {
        ChangeUserDataViewController *userVC = [[ChangeUserDataViewController alloc]init];
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
        
        WeiUserInfo *info = [WeiUserInfo weiUserInfoWithDict:dic];
        
        if ([info.level integerValue]==  3) {
            userVC.isAuthor = NO;
        }else{
            userVC.isAuthor = YES;
        }
        
        [self.navigationController pushViewController:userVC animated:YES];
    }else{
        LoginViewController *userVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:userVC animated:YES];
    }
    
}

- (void)didClickFans{
    
//    MyFollowListViewController *myVC = [[MyFollowListViewController alloc]init];
//    myVC.type = 1;
//    [self.navigationController pushViewController:myVC animated:YES];
//
}

- (IBAction)QRAction:(UIButton *)sender {
    
    QRCodeViewController *myVC = [[QRCodeViewController alloc]init];
    [self.navigationController pushViewController:myVC animated:YES];
    
}


- (IBAction)settingsAction:(UIButton *)sender {
    
    MySettingViewController *orderVC = [[MySettingViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
    
}
@end
