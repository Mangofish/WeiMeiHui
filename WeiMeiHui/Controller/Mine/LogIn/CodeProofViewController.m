//
//  CodeProofViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CodeProofViewController.h"
#import "CodeView.h"
#import "UIButton+CountDown.h"
#import "FAQPageViewController.h"
#import "CYLTabBarControllerConfig.h"
#import "CYLTabBarController.h"
#import "WeiAuthorTabController.h"



@interface CodeProofViewController ()

@property (weak, nonatomic) IBOutlet UILabel *wrongInforLab;

@property (weak, nonatomic) IBOutlet UILabel *inforLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (strong, nonatomic)  CodeView *codeView;
@property (strong, nonatomic)  YYHud *hud;

@property (strong, nonatomic)  NSString *codeStr;

@end

@implementation CodeProofViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
}

- (void)customUI{
    
    
    _backBtn.frame = CGRectMake(0, SafeAreaTopHeight, 40, 40);
    _helpBtn.frame = CGRectMake(kWidth-Space-46, SafeAreaTopHeight, 46, 40);
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(40);
    }];
    
    
    [_inforLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(Space);
    }];
    
    _inforLable.text = [NSString stringWithFormat:@"验证码已发送至 %@",self.tel];
//
    CodeView *v = [[CodeView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_inforLable.frame)+Space, kWidth-80, 60)
                                              num:6
                                        lineColor:[UIColor lightGrayColor]
                                         textFont:30];
    [self.view addSubview:v];
    v.hasUnderLine = YES;
    //分割线
    v.hasSpaceLine = NO;
    
    //输入风格
    v.codeType = CodeViewTypeCustom;
    
    v.EndEditBlcok = ^(NSString *str) {
        NSLog(@"%@",str);
        
        self.codeStr = str;
        [self registAction];
        
    };
    
    _codeView = v;
   
    [_codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(60);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.inforLable.mas_bottom).offset(Space);
    }];
    
    [_wrongInforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.codeView.mas_bottom).offset(Space);
    }];
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.wrongInforLab.mas_bottom).offset(Space*2);
    }];
    
    [self getCodeAction:nil];
}

#pragma -mark- 验证码按钮生效后的时间计时。
- (void)countDown {
    
    [self.codeBtn startWithTime:COUNTS title:@"重新获取验证码" countDownTitle:@"秒后重新获取验证码" mainColor:MainColor countColor:[UIColor clearColor]];
}

- (void)doneWithIt{
    [self.view endEditing:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)getCodeAction:(UIButton *)sender {
    [self codeBtnAction];
}


#pragma -mark- 验证码确认按钮。
- (void)codeBtnAction {
    
  
    //用户名与密码都正确的情况下进行时间的倒计时。
    _wrongInforLab.text = @"";
    [self countDown];
    
    NSString *temp = [self.tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    //请求验证码
    NSString *url = [PublicMethods dataTojsonString:@{@"phone":temp,@"request_time":[self convertTimeSp]}];
    
    [YYNet POST:SendPhoneCode paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([dic[@"success"] integerValue] == 1) {
            
            self.wrongInforLab.hidden = YES;
            self.wrongInforLab.text = @"";
            
        }else{
            
            self.wrongInforLab.hidden = NO;
            self.wrongInforLab.text = dic[@"info"];
            
            
        }
    } faild:^(id responseObject) {
        
    }];
    
    
}

- (void)registAction{
    
    _hud = [[YYHud alloc]init];
    _hud.message = @"登录中...";
    [_hud showInView:self.view];
    
    NSString *inviteid = @"";
    if ([[NSUserDefaults standardUserDefaults] valueForKey:OpenInstallStr]) {
        inviteid = [[NSUserDefaults standardUserDefaults] valueForKey:OpenInstallStr];
    }
    
//    
//    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
//        
//       
//        //弹出提示框(便于调试，调试完成后删除此代码)
//        NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
//        NSString *getData;
//        if (appData.data) {
//            //中文转换，方便看数据
//            getData = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:appData.data options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//        }
//        
//        [[NSUserDefaults standardUserDefaults] setValue:appData.data[@"invite_vid"] forKey:OpenInstallStr];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//   
//        
//    }];
    
    
     NSString *temp = [self.tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"phone":temp,@"code":self.codeStr,@"fromtype":@"our",@"type":@"4",@"invite_vid":inviteid}];
    
    [YYNet POST:ProofCode paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
            
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
            
            
            
            [[NSUserDefaults standardUserDefaults]setObject:dic[@"data"] forKey:@"user"];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:WEICoupon];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
//            判断是不是新用户
            
            if ([[dic[@"data"] objectForKey:@"is_new"] integerValue] == 1) {
                [OpenInstallSDK reportRegister];
            }
            
            //            登录融云
            [self loginRCD];
            //            loading
            [self.hud dismiss];
            
            self.inforLable.text = dic[@"info"];
            self.wrongInforLab.text = @"";
            
            
//            loading
            [self.hud dismiss];
            
            self.inforLable.text = dic[@"info"];
            self.wrongInforLab.text = @"";
            
            
            
        }else{
            
            self.wrongInforLab.hidden = NO;
            self.inforLable.text = @"";
            self.wrongInforLab.text = dic[@"info"];
            [self.hud dismiss];
            [self.codeView emptyEdit];
            [self.codeView beginEdit];
        }
        
        
    } faild:^(id responseObject) {
        
        [self.hud dismiss];
        self.wrongInforLab.hidden = NO;
        self.wrongInforLab.text = @"网络错误，请检查您的网络权限";
        
    }];
    
    
}


- (IBAction)helpAction:(UIButton *)sender {
    
    FAQPageViewController *reVC = [[FAQPageViewController alloc]init];
    [self.navigationController pushViewController:reVC animated:YES];
    
}


- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_codeView beginEdit];
    
}

- (NSString *)convertTimeSp{
    
    NSDate* date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
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


@end
