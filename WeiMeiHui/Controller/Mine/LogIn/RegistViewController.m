//
//  RegistViewController.m
//  WeiMeiHui
//
//  Created by Mac on 2017/6/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "RegistViewController.h"
#import "UIButton+CountDown.h"
#import "NextFreeNewViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "JPUSHService.h"
#import "CYLTabBarControllerConfig.h"
#import "CYLTabBarController.h"
#import "WeiAuthorTabController.h"

#import "TiePhoneViewController.h"
#import "FAQPageViewController.h"

@interface RegistViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIView *lineOne;

@property (weak, nonatomic) IBOutlet UIView *lineTwo;

@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;

@property (weak, nonatomic) IBOutlet UILabel *inforLable;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;

@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIButton *eyesBtn;
@property (strong, nonatomic) YYHud *hud;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customUI];
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 登录
- (IBAction)registAction:(UIButton *)sender {
    
     [PublicMethods requestDeviceInfo];
    
    
    
    //判断用户名，即手机号的位数。
    if (_telTF.text.length == 0 ) {
        _inforLable.text = @"请先输入手机号";
        return;
    }
    if (_telTF.text.length != 13) {
        _inforLable.text = @"手机号码长度错误";
        return;
    }
    
    //判断密码的位数。
    NSString *passText = _pswTF.text;
    if (passText.length == 0) {
        _inforLable.text = @"密码不能为空";
        return;
    }
    

    _inforLable.text = @"";
    NSString *md5Str = [PublicMethods md5:_pswTF.text];
    
     NSString *temp = [self.telTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"phone":temp,@"pwd":md5Str}];
    
        [YYNet POST:LogIn paramters:@{@"json":url} success:^(id responseObject) {
    
            NSDictionary *dic = [solveJsonData changeType:responseObject];
    
            if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                self->_inforLable.hidden = YES;
                
                NSString *tempUser = @"";
                //                判断两次登录信息是否一致
                if ([PublicMethods isLogIn]) {
                    tempUser = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"level"];
                }
                
                if (!tempUser.length && [[dic[@"data"] objectForKey:@"level"] integerValue] == 3) {
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else if ([tempUser integerValue] == [[dic[@"data"] objectForKey:@"level"] integerValue]) {
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else{
                    
                    if ([[dic[@"data"] objectForKey:@"level"] integerValue] == 2 || [[dic[@"data"] objectForKey:@"level"] integerValue] == 1) {
                        
                        [self changeTabbar:2];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }else{
                        
                        [self changeTabbar:1];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }
                    
                }
                
                //存信息
                [[NSUserDefaults standardUserDefaults]setValue:dic[@"data"] forKey:@"user"];
    
                [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:SHOULDREFRESH];
    
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:WEICoupon];
                [[NSUserDefaults standardUserDefaults] synchronize];
    
                NSString *account = @"";
    
                if ([PublicMethods isLogIn]) {
                    account = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"phone"];
                }
    
                [JPUSHService setAlias:account completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    
                    NSLog(@"极光别名注册的回调方法rescode: %ld, \ntags: %ld, \nalias: %@\n", (long)iResCode, (long)seq ,iAlias);
                    if (iResCode == 0) {
                        // 注册成功
                        NSLog(@"极光别名注册的回调成功");
                    }
    
                } seq:0];
    
 
    //            登录融云服务器
                [self loginRCD];
                [self dismissViewControllerAnimated:YES completion:nil];
                
    //            登录极光
                [self logJpush];
    //            self.logComplete(YES);
    
            }else{
                self->_inforLable.hidden = NO;
                self->_inforLable.text = dic[@"info"];
            }
    
        } faild:^(id responseObject) {
            self->_inforLable.hidden = NO;
            self->_inforLable.text = @"网络错误";
        }];
    
    
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
    //[btn setImage:[UIImageimageNamed:@"shouqi"] forState:UIControlStateNormal];//可以设置一个图标。
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [self.telTF setInputAccessoryView:topView];
    [self.pswTF setInputAccessoryView:topView];
   
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
    
    
    
    UIButton *button = [_telTF valueForKey:@"_clearButton"];
    [button setImage:[UIImage imageNamed:@"全删"] forState:UIControlStateNormal];
    
    _telTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIButton *button2 = [_pswTF valueForKey:@"_clearButton"];
    [button2 setImage:[UIImage imageNamed:@"全删"] forState:UIControlStateNormal];
    
    _pswTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.telTF.delegate = self;
    
    [_lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.telTF.mas_bottom).offset(1);
    }];
    
    [_pswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80-40);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineOne.mas_bottom).offset(Space);
    }];
    
    //    self.telTF.delegate = self;
    
    [_lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.pswTF.mas_bottom).offset(1);
    }];
    
    [_inforLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineTwo.mas_bottom).offset(Space);
    }];
    
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineTwo.mas_bottom).offset(40);
    }];
    
    _registBtn.layer.cornerRadius = 20;
    _registBtn.layer.masksToBounds = YES;
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kWidth-80)/2);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.registBtn.mas_bottom).offset(20);
    }];
    
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kWidth-80)/2);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.top.mas_equalTo(self.registBtn.mas_bottom).offset(20);
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
    
    [_eyesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.centerY.mas_equalTo(self.pswTF.mas_centerY).offset(0);
    }];
    
}

- (void)doneWithIt{
    [self.view endEditing:YES];
    
}


- (IBAction)protocolAction:(UIButton *)sender {
    
    NextFreeNewViewController *lists = [[NextFreeNewViewController alloc]init];
    lists.url = @"http://try.wmh1181.com/index.php?s=/Home/AdvertJson/commonWebDetail/id/8";
    [self.navigationController pushViewController:lists animated:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
- (IBAction)forgetAction:(UIButton *)sender {

   TiePhoneViewController  *lists = [[TiePhoneViewController alloc]init];
    lists.type = 1;
    lists.titleInfoStr = @"请填写你要找回密码的微美惠账号";
    lists.titleStr = @"忘记密码";
    [self.navigationController pushViewController:lists animated:YES];
    
}


- (IBAction)eyeAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.pswTF.secureTextEntry = sender.selected;
    
    
}

- (IBAction)codeAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)helpAction:(UIButton *)sender {
    
    FAQPageViewController *reVC = [[FAQPageViewController alloc]init];
    [self.navigationController pushViewController:reVC animated:YES];
    
}


#pragma mark- 第三方登陆
- (IBAction)otherLogin:(UIButton *)sender {
    
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
                 [self signAction:blockUrl andUid:blockUid andtype:type andImage:user.icon andNickname:user.nickname];
             }
             else
             {
                 NSLog(@"微博 %@",error);
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
                 [self signAction:blockUrl andUid:blockUid andtype:type andImage:user.icon andNickname:user.nickname];
             }
             else
             {
                 NSLog(@"微信 %@",error);
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
                 blockUrl = [PublicMethods dataTojsonString:@{@"fromtype":@"weibo",@"weibo_id":user.uid,@"image":user.icon,@"nickname":user.nickname}];
                 blockUid = user.uid;
                 type = @"weibo";
                 [self signAction:blockUrl andUid:blockUid andtype:type andImage:user.icon andNickname:user.nickname];
             }
             else
             {
                 NSLog(@"微博 %@",error);
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
         }];
    }
    
    
}

- (void)signAction:(NSString *)url andUid:(NSString *)uid andtype:(NSString *)type andImage:(NSString *)image andNickname:(NSString *)name{
    
    _hud = [[YYHud alloc]init];
    [_hud showInView:self.view];
    
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
        [self.hud dismiss];
        self->_inforLable.text = @"网络错误，请检查您的网络权限";
        NSLog(@"网络错误%@",responseObject);
        
    }];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [UITextField numberFormatTextField:textField shouldChangeCharactersInRange:range replacementString:string textFieldType:kPhoneNumberTextFieldType];
    
}


@end
