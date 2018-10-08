//
//  TiePhoneViewController.m
//  WeiMeiHui
//
//  Created by Mac on 2017/6/22.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "TiePhoneViewController.h"
#import "UIButton+CountDown.h"
#import <RongIMKit/RongIMKit.h>

#import "CYLTabBarControllerConfig.h"
#import "CYLTabBarController.h"
#import "WeiAuthorTabController.h"
#import "FindPSWViewController.h"
#import "FAQPageViewController.h"


@interface TiePhoneViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *tel;

@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *codesBTn;

@property (weak, nonatomic) IBOutlet UILabel *inforLable;
@property (weak, nonatomic) IBOutlet UIView *lineOne;
@property (weak, nonatomic) IBOutlet UIView *lineTwo;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (weak, nonatomic) IBOutlet UILabel *infoTitleLab;
@end

@implementation TiePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customUI];
    
}

//验证二维码
- (IBAction)tieAction:(UIButton *)sender {
    
    
//    //判断用户名，即手机号的位数。
    if (_tel.text.length == 0 ) {
        _inforLable.text = @"请先输入手机号";
        return;
    }
    if (_tel.text.length != 13) {
        _inforLable.text = @"手机号码长度错误";
        return;
    }
    
    
    if (!_code.text.length) {
        _inforLable.text = @"请输入验证码";
        return;
    }
    
    _inforLable.text = @"";
    
    //验证验证码
    
    

    NSString *ids = @"";
    if ([_fromType isEqualToString:@"qq"]) {
        ids = @"qq_id";
    }
    
    if ([_fromType isEqualToString:@"wechat"]) {
      ids = @"wechat_id";
    }
    
    if ([_fromType isEqualToString:@"weibo"]) {
       ids = @"weibo_id";
    }
    
    NSString *inviteid = @"";
    if ([[NSUserDefaults standardUserDefaults] valueForKey:OpenInstallStr]) {
        inviteid = [[NSUserDefaults standardUserDefaults] valueForKey:OpenInstallStr];
    }
    
    NSString *url = @"";
    
    NSString *temp = [self.tel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    忘记密码
    if (self.type == 1) {
        
        url = [PublicMethods dataTojsonString:@{@"phone":temp,@"type":@"3",@"code":_code.text}];
        
    }else{
        
        url =  [PublicMethods dataTojsonString:@{@"phone":temp,@"fromtype":_fromType,@"code":_code.text,@"uuid":_uuid,@"type":@"2",ids:_ID,@"invite_vid":inviteid}];
        
    }

   
    [YYNet POST:ProofCode paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
        
            if (self.type == 1) {
                
                self->_inforLable.text = dic[@"info"];
                FindPSWViewController *findVC = [[FindPSWViewController alloc]init];
                findVC.tel = self.tel.text;
                [self.navigationController pushViewController:findVC animated:YES];
                return ;
            }
            
            
            
        }
     
        if ([dic[@"data"] isKindOfClass:[NSDictionary class]] && [dic[@"success"] boolValue]) {
            //绑定手机后操作
            
            
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
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }else{
                    
                    [self changeTabbar:1];
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                
            }
            
                [[NSUserDefaults standardUserDefaults]setObject:dic[@"data"] forKey:@"user"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            
                
                //            登录融云服务器
                [self loginRCD];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            self->_inforLable.text = dic[@"info"];
            
        }
        
        
    } faild:^(id responseObject) {
        
        self->_inforLable.text = @"网络错误，请检查您的网络权限";
        
    }];

    
}

#pragma mark-登录融云
-(void)loginRCD{
    
    NSString *rong_token = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"rong_token"];
    
    //            连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:rong_token     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
        
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

- (IBAction)codeAction:(UIButton *)sender {
    
    //判断用户名，即手机号的位数。
    if (_tel.text.length == 0 ) {
        _inforLable.text = @"请先输入手机号";
        return;
    }
    if (_tel.text.length != 13) {
        _inforLable.text = @"手机号码长度错误";
        return;
    }
    
    
    //用户名与密码都正确的情况下进行时间的倒计时。
    _inforLable.text = @"";
    [self countDown];
    
    //请求验证码
    NSString *temp = [self.tel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"phone":temp,@"request_time":[self convertTimeSp]}];
    
    [YYNet POST:SendPhoneCode paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([dic[@"success"] integerValue] == 1) {
            self->_inforLable.text = dic[@"info"];
        }else{
            self->_inforLable.text = dic[@"info"];
        }
    } faild:^(id responseObject) {
        
    }];
    
}

#pragma -mark- 验证码按钮生效后的时间计时。
- (void)countDown {
    
    [self.codesBTn startWithTime:COUNTS title:@"重新获取" countDownTitle:@"s后获取" mainColor:MainColor countColor:[UIColor clearColor]];
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
    [self.tel setInputAccessoryView:topView];
    [self.code setInputAccessoryView:topView];
    
    _backBtn.frame = CGRectMake(0, SafeAreaTopHeight, 40, 40);
    _helpBtn.frame = CGRectMake(kWidth-Space-46, SafeAreaTopHeight, 46, 40);
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY).offset(0);
    }];
    
    if (self.titleStr.length) {
        
        _titleLab.text  = self.titleStr;
        _infoTitleLab.text = self.titleInfoStr;
        
    }
    
    
    [_infoTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(40);
    }];
    
    [_tel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.infoTitleLab.mas_bottom).offset(Space);
    }];
    
    UIButton *button = [_tel valueForKey:@"_clearButton"];
    [button setImage:[UIImage imageNamed:@"全删"] forState:UIControlStateNormal];
    
    _tel.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIButton *button2 = [_code valueForKey:@"_clearButton"];
    [button2 setImage:[UIImage imageNamed:@"全删"] forState:UIControlStateNormal];
    
    _code.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.tel.delegate = self;
    
    [_lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.tel.mas_bottom).offset(1);
    }];
    
    [_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80-10-65);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineOne.mas_bottom).offset(Space);
    }];
    
    //    self.telTF.delegate = self;
    
    [_lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.code.mas_bottom).offset(1);
    }];
    
    [_inforLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineTwo.mas_bottom).offset(Space);
    }];
    
    [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineTwo.mas_bottom).offset(40);
    }];
    
    [_codesBTn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.bottom.mas_equalTo(self.lineOne.mas_top).offset(50);
    }];
    
    _finishBtn.layer.cornerRadius = 20;
    _finishBtn.layer.masksToBounds = YES;
    
   
}

- (void)doneWithIt{
    [self.view endEditing:YES];
    
}
- (IBAction)protocolAction:(UIButton *)sender {
    
    FAQPageViewController *reVC = [[FAQPageViewController alloc]init];
    [self.navigationController pushViewController:reVC animated:YES];
    
}

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [UITextField numberFormatTextField:textField shouldChangeCharactersInRange:range replacementString:string textFieldType:kPhoneNumberTextFieldType];
    
}

- (NSString *)convertTimeSp{
    
    NSDate* date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
}

@end
