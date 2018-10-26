//
//  MySettingViewController.m
//  WeiMeiHui
//
//  Created by Mac on 2017/6/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MySettingViewController.h"
#import "ChangePSWViewController.h"
//#import "XGPush.h"
#import <RongIMKit/RongIMKit.h>
#import "WeiAuthorTabController.h"
#import "FeedbackViewController.h"

#import "LLTabBar.h"
#import "LWShareService.h"
#import "ShareService.h"

#import "JPUSHService.h"

#import "CYLTabBarControllerConfig.h"
#import "CYLTabBarController.h"
#import "ZYInputAlertView.h"
#import "TYAlertController+BlurEffects.h"

@interface MySettingViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *dataAry;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    if ([PublicMethods isLogIn]) {
        _quitBtn.hidden = NO;
        dataAry = @[@"清除缓存",@"意见反馈",@"分享APP",@"修改密码",@"添加邀请人"];
    }else{
   _quitBtn.hidden = YES;
        dataAry = @[@"清除缓存",@"意见反馈",@"分享APP"];
    }
    
    [self configNavView];
    
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);
//        make.height.mas_equalTo(buttonWidth);、
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
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight, kWidth, dataAry.count*44);
    
   
}



- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataAry.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = dataAry[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor =FontColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (indexPath.row == 0) {
        NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize]; //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
        float MBCache = bytesCache/1000/1000;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%luM",(unsigned long)MBCache];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [[SDImageCache sharedImageCache] clearDisk];
        [self.mainTableView reloadData];
    }
    
    if (indexPath.row == 1) {
        if (![PublicMethods isLogIn]) {
            
            LoginViewController *logVc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:logVc animated:YES];
            return;
        }
        
        FeedbackViewController *reVC = [[FeedbackViewController alloc]init];
        [self.navigationController pushViewController:reVC animated:YES];
    }
    
//    分享APP
    if (indexPath.row == 2) {
       
        NSString *url = [[NSUserDefaults standardUserDefaults] valueForKey:ShareAppUrl];
         NSString *content = [[NSUserDefaults standardUserDefaults] valueForKey:ShareAppContent];
         NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:ShareAppPic];
         NSString *title = [[NSUserDefaults standardUserDefaults] valueForKey:ShareAppTitle];
        
        [LWShareService shared].shareBtnClickBlock = ^(NSUInteger index) {
            NSLog(@"%lu",(unsigned long)index);
            [[LWShareService shared] hideSheetView];
            
            
//            if ([PublicMethods isLogIn]) {
            
                //    分享界面
                SSDKPlatformType type = 0;
                
                switch (index) {
                    case 0:
                        type = SSDKPlatformSubTypeWechatTimeline;
                        break;
                    case 1:
                        type = SSDKPlatformSubTypeWechatSession;
                        break;
                    case 2:
                        type = SSDKPlatformTypeSinaWeibo;
                        break;
                    case 3:
                        type = SSDKPlatformSubTypeQQFriend;
                        break;
                    case 4:
                        type = SSDKPlatformSubTypeQZone;
                        break;
                    case 5:
                        type = SSDKPlatformTypeCopy;
                        break;
                    default:
                        break;
                }
                
                
                    
                    [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
                
        
//            }
            
        };
        [[LWShareService shared] showInViewControllerTwo:self];
        
    }
    
    if (indexPath.row == 3) {
        ChangePSWViewController *reVC = [[ChangePSWViewController alloc]init];
        [self.navigationController pushViewController:reVC animated:YES];
    }
    
    if (indexPath.row == 4) {
       
        ZYInputAlertView *alertView = [ZYInputAlertView alertView];
        [alertView.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        alertView.placeholder = @"输入邀请码";
        alertView.titleLab.text = @"请输入邀请码";
        [alertView confirmBtnClickBlock:^(NSString *inputString) {
            
            //网络请求
            NSString *uuid = @"";
            if ([PublicMethods isLogIn]) {
                uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
            }
            
            NSString *deviceID = [PublicMethods requestDeviceInfo][0];
            
            NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"invite_id":inputString,@"device_id":deviceID}];
            
            [YYNet POST:UpdateInviteVID paramters:@{@"json":url} success:^(id responseObject) {
                
                NSDictionary *dic = [solveJsonData changeType:responseObject];
                
                if ([dic[@"success"] boolValue]) {
                   
                    //                [self getData];
                    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"" message:dic[@"info"]];
                    
                    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                        NSLog(@"%@",action.title);
                    }]];
                    
                    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet transitionAnimation:TYAlertTransitionAnimationFade];
                    alertController.backgoundTapDismissEnable = YES;
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }else{
                    
                    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"" message:dic[@"info"]];
                    
                    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                        NSLog(@"%@",action.title);
                    }]];
                    
                    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet transitionAnimation:TYAlertTransitionAnimationFade];
                    alertController.backgoundTapDismissEnable = YES;
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }
                
                
            } faild:^(id responseObject) {
                
            }];
            
        }];
        
          [alertView show];
        
    }
}

- (IBAction)signOutAction:(UIButton *)sender {
    

   
    
    
   

    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"level"] integerValue] != 3) {
        
        WeiAuthorTabController *authorVC = [[WeiAuthorTabController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = authorVC;
        
    }else{
      
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:SHOULDREFRESH];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:WEICoupon];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[RCIMClient sharedRCIMClient] logout];
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
        NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, @"tag" , iAlias);
        
    } seq:0];
    
}

//- (void)delAccount {
//
//    [XGPush delAccount:^{
//        NSLog(@"[XGDemo] Del account success");
//
//    } errorCallback:^{
//        NSLog(@"[XGDemo] Del account error");
//    }];
//
//
//}


@end
