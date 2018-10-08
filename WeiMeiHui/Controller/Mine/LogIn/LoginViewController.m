//
//  LoginViewController.m
//  WeiMeiHui
//
//  Created by Mac on 17/5/4.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "RegistViewController.h"
#import "ZYKeyboardUtil.h"
#import "FindPSWViewController.h"
#import <RongIMKit/RongIMKit.h>

#import "CYLTabBarControllerConfig.h"
#import "CYLTabBarController.h"
#import "WeiAuthorTabController.h"
#import "TiePhoneViewController.h"

#import "JPUSHService.h"
#import "CodeProofViewController.h"
#import "FAQPageViewController.h"
#import "NextFreeNewViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *inforLable;

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@property (weak, nonatomic) IBOutlet UITextField *telTF;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

@property (weak, nonatomic) IBOutlet UIButton *pwBtn;

@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;

@property (strong, nonatomic) YYHud *hud;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
   
    [self customUI];
}

- (void)customUI{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    //        [topView setBarStyle:UIBarStyleBlackTranslucent];//设置增加控件的基本样式，UIBarStyleDefault为默认样式。
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(doneWithIt) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"确定" forState:(UIControlStateNormal)];
    btn.backgroundColor = MainColor;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [self.telTF setInputAccessoryView:topView];
    
    
    _backBtn.frame = CGRectMake(0, SafeAreaTopHeight, 40, 40);
    _helpBtn.frame = CGRectMake(kWidth-Space-46, SafeAreaTopHeight, 46, 40);
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(40);
    }];
    
    [_telTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Space);
    }];
    
    self.telTF.delegate = self;
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.telTF.mas_bottom).offset(1);
    }];
    
    [_inforLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.line.mas_bottom).offset(Space);
    }];
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.inforLable.mas_bottom).offset(40);
    }];
    
    _codeBtn.layer.cornerRadius = 20;
    _codeBtn.layer.masksToBounds = YES;
    
    [_pwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kWidth-80)/2);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.codeBtn.mas_bottom).offset(20);
    }];
    

    
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:
                                        @"登录代表你已同意《微美惠用户服务协议》"];
    NSRange titleRange = {8,11};
    
    NSRange titleRanget = {0,8};
    
    NSDictionary *dic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName: [UIColor colorWithRed:46/255.0 green:160/255.0 blue:242/255.0 alpha:1],NSUnderlineColorAttributeName: [UIColor colorWithRed:46/255.0 green:160/255.0 blue:242/255.0 alpha:1]};
    
    [title addAttributes:dic range:titleRange];
    
    NSDictionary *dic2 = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    [title addAttributes:dic2 range:titleRanget];
    
    [_protocolBtn setAttributedTitle:title
                      forState:UIControlStateNormal];
    
    
    //    协议按钮
    [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kWidth-80));
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(SafeAreaBottomHeight+20));
    }];
    
//    三方登录
    
    [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo((kWidth-80)/2);
//        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.view.mas_left).offset(kWidth/3);
        make.bottom.mas_equalTo(self.protocolBtn.mas_top).offset(-60);
    }];
    
    [_wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.mas_equalTo((kWidth-80)/2);
        //        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.view.mas_right).offset(-kWidth/3);
        make.bottom.mas_equalTo(self.protocolBtn.mas_top).offset(-60);
    }];
    
}

- (void)doneWithIt{
    [self.view endEditing:YES];
    
}

- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark- 登陆
- (IBAction)signInAction:(UIButton *)sender {
    
    CodeProofViewController *reVC = [[CodeProofViewController alloc]init];
    reVC.tel = self.telTF.text;
    [self.navigationController pushViewController:reVC animated:YES];
    
}





#pragma mark-登录融云
-(void)loginRCD{
    
    NSString *rong_token = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"rong_token"];
    
    
    //            连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:rong_token     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
     
//        [[RCIM sharedRCIM] setUserInfoDataSource:self.tabBarController];
//        [[RCIM sharedRCIM] setReceiveMessageDelegate:self.tabBarController];
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        NSLog(@"token错误");
    }];
    
}




#pragma mark-密码登录
- (IBAction)forgetPasswords:(UIButton *)sender {
    
    RegistViewController *reVC = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:reVC animated:YES];

    
}

#pragma mark- 帮助
- (IBAction)signUpAction:(UIButton *)sender {
    
    FAQPageViewController *reVC = [[FAQPageViewController alloc]init];
    [self.navigationController pushViewController:reVC animated:YES];
    
}


#pragma mark- 加入微美惠


- (void)changeTabbar:(NSUInteger )type{
    
//    手艺人
    if (type == 2) {
        
        CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
        CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
        [[UIApplication sharedApplication].keyWindow setRootViewController:tabBarController];
        
    }
    
//    普通
    if (type == 1) {
        
        WeiAuthorTabController *authorVC = [[WeiAuthorTabController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = authorVC;
        
         
    }
    
    
}

#pragma mark- 第三方登陆
- (IBAction)otherLogin:(UIButton *)sender {
    
    _hud = [[YYHud alloc]init];
    [_hud showInView:self.view];
    
    NSString *url = @"";
    NSString *uid = @"";
    NSString *fromType = @"";
//    QQ
    if (sender.tag == 1) {
        [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             __block NSString *blockUrl = url;
             __block NSString *blockUid = uid;
             __block NSString *type = fromType;
             if (state == SSDKResponseStateSuccess)
             {
                 
                 NSString *sex = @"";
                 if (user.gender == 1) {
                     
                     sex = @"2";
                     
                 }else{
                     sex = @"1";
                 }
                 
                 
                 blockUrl = [PublicMethods dataTojsonString:@{@"fromtype":@"qq",@"qq_id":user.uid,@"image":user.icon,@"nickname":user.nickname,@"sex":sex}];
                 
                 blockUid = user.uid;
                 type = @"qq";
                 [self signAction:blockUrl andUid:blockUid andtype:type];
             }
             else
             {
                 NSLog(@"微博 %@",error);
                 [self.hud dismiss];
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
         }];
        
    }
    
//    微信
    if (sender.tag == 2) {
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             __block NSString *blockUrl = url;
             __block NSString *blockUid = uid;
             __block NSString *type = fromType;
             if (state == SSDKResponseStateSuccess)
             {
                 
                 NSString *sex = @"";
                 if (user.gender == 1) {
                   
                     sex = @"2";
                     
                 }else{
                     sex = @"1";
                 }
                 
                 
                 
                 blockUrl = [PublicMethods dataTojsonString:@{@"fromtype":@"wechat",@"wechat_id":user.uid,@"image":user.icon,@"nickname":user.nickname,@"sex":sex}];
                 blockUid = user.uid;
                 type = @"wechat";
                 [self signAction:blockUrl andUid:blockUid andtype:type];
             }
             else
             {
                 NSLog(@"微信 %@",error);
                 [self.hud dismiss];
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
         }];
        
    }
    
//    微博
    if (sender.tag == 3) {
        [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
        [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             __block NSString *blockUrl = url;
             __block NSString *blockUid = uid;
             __block NSString *type = fromType;
             if (state == SSDKResponseStateSuccess)
             {
                 blockUrl = [PublicMethods dataTojsonString:@{@"fromtype":@"weibo",@"weibo_id":user.uid,@"image":user.icon,@"nickname":user.nickname,@"sex":@(user.gender)}];
                 blockUid = user.uid;
                 type = @"weibo";
                 [self signAction:blockUrl andUid:blockUid andtype:type];
             }
             else
             {
                 NSLog(@"微博 %@",error);
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
         }];
    }
    
    
    
    
}

- (void)signAction:(NSString *)url andUid:(NSString *)uid andtype:(NSString *)type{
    
    NSLog(@"三方登录 %@",url);
    
    
    [YYNet POST:SignIn paramters:@{@"json":url} success:^(id responseObject) {
        NSDictionary *dic = [solveJsonData changeType:responseObject];//调用一个字典类型的变量，将其转化为JSON数据。
        [self.hud dismiss];
        if ([[dic objectForKey:@"status"] intValue] == 0) {
            self->_inforLable.text = dic[@"info"];
            
        }else{
            
            if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                NSString *phone = [dic[@"data"] objectForKey:@"phone"];
                if (!phone.length) {
                    
                    //绑定手机
                    TiePhoneViewController *tie = [[TiePhoneViewController alloc]init];
                    tie.fromType = type;
                    tie.uuid = [dic[@"data"] objectForKey:@"uuid"];
                    tie.ID = uid;
                    [self.navigationController pushViewController:tie animated:YES];
                    
                }else{
                    
                    [[NSUserDefaults standardUserDefaults] setValue:dic[@"data"] forKey:@"user"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                
                
                
            }else{
                self->_inforLable.text = @"数据错误";
            }
            
        }
        
    } faild:^(id responseObject) {
        
//        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        [self.hud dismiss];
        self->_inforLable.text = @"网络错误，请检查您的网络权限";
        
    }];
    
    
}

- (void)logJpush{
    
    NSString *account = @"";
    
    if ([PublicMethods isLogIn]) {
        account = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"phone"];
    }
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
            [JPUSHService setAlias:account completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
                NSLog(@"极光别名注册的回调方法rescode: %ld, \ntags: %ld, \nalias: %@\n", (long)iResCode, (long)seq ,iAlias);
                if (iResCode == 0) {
                    // 注册成功
                    NSLog(@"极光别名注册的回调成功");
                }
                
            } seq:0];
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
        
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"电话号码%@，range：%@",string,NSStringFromRange(range));
    
    if ( (range.location-range.length) == 12 ) {
        _codeBtn.backgroundColor = MainColor;
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _codeBtn.enabled = YES;
        
    }else{
        
        _codeBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:167/255.0 blue:173/255.0 alpha:1];
        [_codeBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:222/255.0 blue:225/255.0 alpha:1] forState:UIControlStateNormal];
        _codeBtn.enabled = NO;
        
    }
    
    return [UITextField numberFormatTextField:textField shouldChangeCharactersInRange:range replacementString:string textFieldType:kPhoneNumberTextFieldType];
    
    
}


- (IBAction)protocolAction:(UIButton *)sender {
    
    NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
    lists.url = @"http://try.wmh1181.com/index.php?s=/Home/AdvertJson/commonWebDetail/id/8";
    [self.navigationController pushViewController:lists animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
@end
