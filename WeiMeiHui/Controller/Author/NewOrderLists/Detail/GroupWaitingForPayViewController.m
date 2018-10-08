//
//  GroupWaitingForPayViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GroupWaitingForPayViewController.h"

#import "GoodsDetailSmallTableViewCell.h"
#import "ALLAuthorsTableViewCell.h"
#import "JoinGroupTableViewCell.h"
#import "PayStyleViewController.h"

#import "LWShareService.h"
#import "ShareService.h"

@interface GroupWaitingForPayViewController ()<UITableViewDelegate,UITableViewDataSource,JoinGroupTableViewCellDelegate>
{
    NSMutableDictionary *heightDic;
    NSDictionary *dataDic;
}

@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation GroupWaitingForPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    [self getData];
}

- (void)configNavView {
    
    if ([self.type integerValue] == 4) {
        _cancelBtn.hidden = YES;
    }
    
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
    _titleLab.text = self.titleStr;
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    _mainTableView.frame = CGRectMake(0, SafeAreaHeight+1, kWidth, kHeight-SafeAreaHeight-1);
//

    self.mainTableView.delegate  =self;
    self.mainTableView.dataSource = self;
    
    if ([self.type integerValue] != 2) {
        self.payBtn.hidden = NO;
    }
}


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!dataDic) {
        return 0;
    }

    if ([self.type integerValue] == 2) {
        return 3;
    }
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        
        if ([self.type integerValue] == 3) {
            return 4;
        }
        
        
        if ([self.type integerValue] == 4) {
            return 1;
        }
        
        return 3;
    }
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            if ([self.type integerValue] == 4) {
                return 40;
            }
            
            return 60;
        }
        
        if (indexPath.row == 1) {
            return 88;
        }
        
        return 44;
    }
    
    if (indexPath.section == 2) {
        
        return 186;
        
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
        
        if (dataDic) {
            cell.order = [GoodsDetail authorGoodsWithDict:dataDic];
        }
        
        
        cell.status.text = self.status;
        return cell;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellFour];
            
            if (dataDic) {
                 cell.goodsDetail = [GoodsDetail authorGoodsWithDict:dataDic];
            }
           
            return cell;
        }
        
        
        if ([self.type integerValue] == 4) {
            
            if (indexPath.row == 1) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                return cell;
            }
            
        }
        
        if (indexPath.row == 1) {
            ALLAuthorsTableViewCell *cell = [ALLAuthorsTableViewCell allAuthorsTableViewCell];
            
            cell.author = [ShopAuthor shopAuthorWithDict:dataDic];
            return cell;
        }
        
        if ([self.type integerValue] == 3) {
            
            if (indexPath.row == 2) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellOne];
                cell.goodsDetail = [GoodsDetail authorGoodsWithDict:dataDic];
                return cell;
            }
            
            if (indexPath.row == 3) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                return cell;
            }
            
        }else{
            if (indexPath.row == 2) {
                GoodsDetailSmallTableViewCell *cell = [GoodsDetailSmallTableViewCell goodsDetailSmallTableViewCellThree];
                return cell;
            }
        }
        
    }
    
    JoinGroupTableViewCell *cell = [JoinGroupTableViewCell joinGroupTableViewCell];
   
    
    if ([self.status isEqualToString:@"待付款"]) {
         cell.goodsWaitDetail = [GoodsDetail authorGoodsWithDict:dataDic];
        [cell.joinBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }else{
         cell.goodsDetail = [GoodsDetail authorGoodsWithDict:dataDic];
        [cell.joinBtn setTitle:@"邀请好友拼团" forState:UIControlStateNormal];
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
    
    NSString *path = @"";
    if ([self.type integerValue] == 1) {
        path = PayOrderDetail;
    }
    
    if ([self.type integerValue] == 2) {
        path = GroupOrderDetails;
    }
    
    if ([self.type integerValue] == 3) {
        path = ActOrderDetails;
    }
    
    if ([self.type integerValue] == 4) {
        path = WeiOrderDetail;
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":_ID,@"lat":lat,@"lng":lng}];
    
    [YYNet POST:path paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self->dataDic = dic[@"data"];
        
        [self.mainTableView reloadData];
        
    } faild:^(id responseObject) {
        
    }];
    
}



#pragma  mark - 去参与拼团
- (void)didSelectJoinGroup{
    
//    支付
     if ([self.status isEqualToString:@"待付款"]) {
        
        PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
        payVC.ordernumber = [dataDic objectForKey:@"order_number"];
        payVC.price = [dataDic objectForKey:@"group_price"];
        payVC.notifyUrlAli = AliGroupSingleNotifyUrl;
        payVC.notifyUrlWeixin = WXGroupSingleNotifyUrl;
         
        
        
         
         
        
        [self.navigationController pushViewController:payVC animated:YES];
        
    }else{
        
//邀请
        
        NSString *url = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"share_url"]];
       NSString *content = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"shareContent"]];
        NSString *title = [dataDic objectForKey:@"shareTitle"];
        NSString *pic = [dataDic objectForKey:@"sharePic"];
        
        [LWShareService shared].shareBtnClickBlock = ^(NSUInteger index) {
            NSLog(@"%lu",(unsigned long)index);
            [[LWShareService shared] hideSheetView];
            
            
            if ([PublicMethods isLogIn]) {
                
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
                    case 6:
                    {
                       
                    }
                        break;
                    default:
                        break;
                }
                
                [[ShareService shared] shareType:type url:[NSURL urlWithNoBlankDataString:url] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:url];
               
                
            }else{
                LoginViewController *log = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:log animated:YES];
            }
            
        };
        
        
         [[LWShareService shared] showInViewControllerTwo:self];
        
    }

}


#pragma  mark - 去支付
- (IBAction)payAction:(UIButton *)sender {
    
    PayStyleViewController *payVC =[[ PayStyleViewController alloc] init];
    payVC.ordernumber = [dataDic objectForKey:@"order_number"];
    payVC.price = [dataDic objectForKey:@"pay_price"];
    payVC.notifyUrlAli = AliGroupMuchNotifyUrl;
    payVC.notifyUrlWeixin = WXGroupMuchNotifyUrl;
    
    if ([self.type integerValue] == 4) {
        payVC.notifyUrlAli = @"http://try.wmh1181.com/WMHFriend/Activity/AliCutPay";
        payVC.notifyUrlWeixin = @"http://try.wmh1181.com/WMHFriend/Activity/WeCutPay";
    }
    
    [self.navigationController pushViewController:payVC animated:YES];
    
}


#pragma  mark - 取消订单
- (IBAction)cancelAction:(UIButton *)sender {
    
    NSString *url = [PublicMethods dataTojsonString:@{@"order_num":dataDic[@"order_number"]}];
    
    [YYNet POST:OrderDetailCancel paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已取消" iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            [self.navigationController popViewControllerAnimated:YES];
            return;
            
        }else{
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
        }
        
    } faild:^(id responseObject) {
        
    }];
    
    
}
@end
