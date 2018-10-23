//
//  FindPSWViewController.m
//  WeiMeiHui
//
//  Created by Mac on 2017/6/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "FindPSWViewController.h"
#import "UIButton+CountDown.h"
#import "UIButton+WebCache.h"

@interface FindPSWViewController () <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIView *lineOne;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UILabel *inforLable;
@property (weak, nonatomic) IBOutlet UILabel *infoTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *eyesBtn;

@end

@implementation FindPSWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    //[btn setImage:[UIImageimageNamed:@"shouqi"] forState:UIControlStateNormal];//可以设置一个图标。
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    
    [self.pswTF setInputAccessoryView:topView];
    
    _backBtn.frame = CGRectMake(0, SafeAreaTopHeight, 40, 40);
    
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY).offset(0);
    }];
    
    [_infoTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(40);
    }];
    
    [_pswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80-40);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.infoTitleLab.mas_bottom).offset(Space);
    }];
    
    UIButton *button = [_pswTF valueForKey:@"_clearButton"];
    [button setImage:[UIImage imageNamed:@"全删"] forState:UIControlStateNormal];
    
    _pswTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    [_lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.pswTF.mas_bottom).offset(1);
    }];
    
    
//        self..delegate = self;

    
    [_inforLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineOne.mas_bottom).offset(Space);
    }];
    
    _infoTitleLab.text = [NSString stringWithFormat:@"请为你的账号%@设置新密码",self.tel];
    
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineOne.mas_bottom).offset(40);
    }];
    
    _registBtn.layer.cornerRadius = 20;
    _registBtn.layer.masksToBounds = YES;
    
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


- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




- (IBAction)eyeAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.pswTF.keyboardType = UIKeyboardTypeEmailAddress;
    self.pswTF.secureTextEntry = sender.selected;
    
}


- (IBAction)confirmAction:(UIButton *)sender {
    
    //判断密码的位数。
    NSString *passText = _pswTF.text;
    if (passText.length < 6) {
        _inforLable.text = @"请设置六位数以上密码";
        return;
    }
    
    
    _inforLable.text = @"";
    NSString *temp = [self.tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *md5Str = [PublicMethods md5:_pswTF.text];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"phone":temp,@"pwd":md5Str}];
    
    [YYNet POST:ProofCode paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
            
             self.inforLable.text = dic[@"info"];
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message: dic[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
            //存信息
            [[NSUserDefaults standardUserDefaults]setValue:dic[@"data"] forKey:@"user"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            self.inforLable.text = dic[@"info"];
            
        }
        
    } faild:^(id responseObject) {
        
        self->_inforLable.hidden = NO;
        self->_inforLable.text = @"网络错误，请检查您的网络权限";
        
    }];
    
    
}



@end
