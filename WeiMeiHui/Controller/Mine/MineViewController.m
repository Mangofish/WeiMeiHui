//
//  MineViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MineViewController.h"
#import "MineFirstTableViewCell.h"
#import "MineHeaderView.h"
#import "MyOrderListViewController.h"
#import "MyCommentListViewController.h"
#import "MyFollowListViewController.h"
#import "MyPulishedWorkViewController.h"
#import "ChangeUserDataViewController.h"
#import "LoginViewController.h"
#import "MySettingViewController.h"
#import "SecondKillsViewController.h"

#import "NextFreeNewViewController.h"

#import "ActivityThreeTableViewCell.h"
#import "MyCouponsViewController.h"
#import "MyCouponListsViewController.h"
#import "MyCardsListsViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,MineHeaderViewDelegate>{
    WeiUserInfo *user;
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *erBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *saoBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, copy) NSArray *listAry;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
//    注册通知
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redPointNotify:) name:@"redPointNotify" object:nil];
    
    [self configNavView];
    
}

#pragma mark- 通知回调
- (void)redPointNotify:(NSNotification *)info {
    
    //    跳转页面
//    NSDictionary *dic = info.userInfo;
    
    //    加红点
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:UNREAD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tabBarController.tabBar  showBadgeOnItmIndex:4 tabbarNum:5];
        [self.mainTableView reloadData];
        
    });
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self getData];
    
    [self getDataT];
    
    if ([PublicMethods isHaveMessage]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar  hideBadgeOnItemIndex:4];
        });
    }
    
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_erBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(24);
//        make.height.mas_equalTo(24);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-Space);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.erBtn.mas_centerY);
    }];
    
    [_saoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(24);
//        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.erBtn.mas_centerY);
    }];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.frame = CGRectMake(0, 0, kWidth, kHeight-48);
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"优惠券";
            cell.imageView.image = [UIImage imageNamed:@"优惠券icon"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = LightFontColor;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            if ([user.coupon_count integerValue] == 0) {
                cell.detailTextLabel.text = @"暂无可用优惠券";
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"你有%@张可用优惠券",user.coupon_count];
            }
            
            
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"会员卡包";
            cell.imageView.image = [UIImage imageNamed:@"会员卡包"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.separatorInset = UIEdgeInsetsMake(44, 0, 0, 0);
        return cell;
        
    }else{
        
        ActivityThreeTableViewCell *cell = [ActivityThreeTableViewCell activityThreeTableViewCellSingle];
        [cell.singleImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:[self.listAry[indexPath.section-2] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"test2"]];
        return cell;
        
    }
    
    

    
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (section == 0) {
        return 0;
    }
    
    if ( section == 1) {
        return 2;
    }
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2+self.listAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section >= 2) {
        return 120;
    }
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        if ([PublicMethods isLogIn]) {
            
//            区分手艺人
            
            MineHeaderView *v = [MineHeaderView headerViewLoginWithFrame:CGRectMake(0, 0, kWidth, 200)];
            if (user) {
                
                v.user = user;
                
            }
            
            v.delegate = self;
            return v;
            
        }else{
            
            MineHeaderView *v = [MineHeaderView headerViewNotLogWithFrame:CGRectMake(0, 0, kWidth, 200)];
            
            v.delegate = self;
            return v;
            
        }
        
        
    }
    
    if (section == 2) {
        
        UIView *v = [[UIView alloc]init];
        v.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(Space, 0, kWidth, 50)];
        l.textColor = FontColor;
        l.text = @"微美惠推荐";
        l.font = [UIFont systemFontOfSize:14];
        [v addSubview:l];
        return v;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 200;
    }
    if (section == 2) {
        return 50;
    }
    return Space;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    MySettingViewController *orderVC = [[MySettingViewController alloc]init];
//    [self.navigationController pushViewController:orderVC animated:YES];
//    return;
    
   
    
    if (![PublicMethods isLogIn]) {
        LoginViewController *userVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:userVC animated:YES];
        return;
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            MyCouponListsViewController *orderVC = [[MyCouponListsViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        
        if (indexPath.row == 1) {
            
            MyCardsListsViewController *pubVC = [[MyCardsListsViewController alloc]init];
            [self.navigationController pushViewController:pubVC animated:YES];;
        }
        
    }
    
    if (indexPath.section >= 2) {
        
        NSString *url = [self.listAry[indexPath.section-2] objectForKey:@"url"];
        
        if (url.length) {
            NextFreeNewViewController *pubVC = [[NextFreeNewViewController alloc]init];
            pubVC.url = [self.listAry[indexPath.section-2] objectForKey:@"url"];
            [self.navigationController pushViewController:pubVC animated:YES];;
            
        }else{
            
            SecondKillsViewController *lists = [[SecondKillsViewController alloc]init];
            [self.navigationController pushViewController:lists animated:YES];
            
        }
        
        
        
        
    }
    
    
}

- (void)getData{
  
     NSString *uuid =@"";
    if ([PublicMethods isLogIn]) {
         uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
   
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid}];
    
    [YYNet POST:MINE paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        
        if ([dict[@"data"] isKindOfClass:[NSDictionary class]]) {
            
//            [[NSUserDefaults standardUserDefaults] setValue:dict[@"data"] forKey:@"userMine"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
            self->user = [WeiUserInfo weiUserInfoWithDict:dict[@"data"]];
            
            if ([[dict[@"data"] objectForKey:@"recommend"] isKindOfClass:[NSArray class]]) {
                 self.listAry = [dict[@"data"] objectForKey:@"recommend"];
            }
           
            [self.mainTableView reloadData];
            
        }
       
        
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
//    作品
    if (index == 1) {
        
        MyPulishedWorkViewController *myVC = [[MyPulishedWorkViewController alloc]init];
        
        myVC.type = 1;
        [self.navigationController pushViewController:myVC animated:YES];
        
    }
    
    //    收藏
    if (index == 2) {
        
        MyPulishedWorkViewController *myVC = [[MyPulishedWorkViewController alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
        
    }
    
    //    关注
    if (index == 3) {
        MyFollowListViewController *myVC = [[MyFollowListViewController alloc]init];
        [self.navigationController pushViewController:myVC animated:YES];
       
    }
    
    //    粉丝
    if (index == 4) {
        MyFollowListViewController *myVC = [[MyFollowListViewController alloc]init];
        myVC.type  = 1;
        [self.navigationController pushViewController:myVC animated:YES];
    }
    
}

//修改资料
- (void)didClickIconBtn{
    
    if ([PublicMethods isLogIn]) {
        ChangeUserDataViewController *userVC = [[ChangeUserDataViewController alloc]init];
        
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
        
        WeiUserInfo *info = [WeiUserInfo weiUserInfoWithDict:dic];
        
        if ([info.level integerValue] ==  2) {
            userVC.isAuthor = YES;
        }else{
            userVC.isAuthor = NO;
        }
        
        [self.navigationController pushViewController:userVC animated:YES];
    }else{
        LoginViewController *userVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:userVC animated:YES];
    }
    
}

- (void)didClickFans{
    
        MySettingViewController *orderVC = [[MySettingViewController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
}


#pragma mark - 获取数据
- (void)getDataT{
    
    
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *uuid = @"";
    
    if ([PublicMethods isLogIn]) {
        uuid  = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    if (!city_id.length) {
        city_id = @"";
    }
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":@(1),@"lat":lat,@"lng":lng}];
    
    [YYNet POST:INDEXList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        
        NSUInteger type = [[dic[@"order_data"] objectForKey:@"type"] integerValue];
        
        [[NSUserDefaults standardUserDefaults] setValue:@(type) forKey:WEIPUBLISH];
        
        
        
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}

@end
