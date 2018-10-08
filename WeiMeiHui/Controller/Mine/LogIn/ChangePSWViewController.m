//
//  ChangePSWViewController.m
//  WeiMeiHui
//
//  Created by Mac on 2017/6/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ChangePSWViewController.h"
#import "WeiUserInfo.h"
#import "ProofPswViewController.h"

@interface ChangePSWViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *changePswOne;
@property (weak, nonatomic) IBOutlet UITextField *changePswTwo;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UITextField *oldPsw;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;

@property (weak, nonatomic) IBOutlet UIButton *forgretBtn;
@end

@implementation ChangePSWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.changePswOne.delegate = self;
    self.changePswTwo.delegate = self;
    
    self.backTop.constant = SafeAreaTopHeight;
    self.titleTop.constant = SafeAreaTopHeight;
    
    
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
    [self.changePswOne setInputAccessoryView:topView];
    [self.changePswTwo setInputAccessoryView:topView];
    [self.oldPsw setInputAccessoryView:topView];
    
    _forgretBtn.frame = CGRectMake(kWidth-Space- 60, SafeAreaTopHeight, 60, 25);

}

- (void)doneWithIt{
    
    [self.changePswOne resignFirstResponder];
    [self.changePswTwo resignFirstResponder];
    [self.oldPsw resignFirstResponder];
    
}


- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([self.changePswOne.text isEqualToString:self.changePswTwo.text] && self.changePswOne.text.length) {
        self.rightBtn.hidden = NO;
    }else{
        self.rightBtn.hidden = YES;
    }
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    if (textField ==  _oldPsw) {
        
        _info.text = @"";
    }
    
    return YES;
    
}

- (IBAction)confirmAction:(UIButton *)sender {
    
    NSString *inforText = @"";
//    if (_oldPsw.text.length < 6 ) {
//        
//        inforText = @"密码长度不能低于六位";
//        _info.text = inforText;
//        _info.hidden = NO;
//        return;
//    }

    //判断密码位数的长度，如果位数为0或位数小于6，都会显示相应信息。
    if (_changePswOne.text.length == 0 || _changePswTwo.text.length == 0) {
        
        inforText = @"密码不能为空";
        _info.text = inforText;
        _info.hidden = NO;
        return;
    }
    
    if (_changePswOne.text.length < 6 || _changePswTwo.text.length<6) {
        
        inforText = @"新密码长度不能低于六位";
        _info.text = inforText;
        _info.hidden = NO;
        return;
    }
    
    if (![_changePswOne.text isEqualToString:_changePswTwo.text]) {
        
        inforText = @"两次密码不符";
        _info.text = inforText;
        _info.hidden = NO;
        _rightBtn.hidden = YES;
        return;
    }else{
        _rightBtn.hidden = NO;
    }
    
    //网络请求
    NSString *md5Str = [PublicMethods md5:_changePswOne.text];
    NSString *md5Str2 = [PublicMethods md5:_oldPsw.text];
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    WeiUserInfo * user = [WeiUserInfo weiUserInfoWithDict:userDict];
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":user.uuid,@"newpwd":md5Str,@"old_pwd":md5Str2}];
    
    [YYNet POST:ChangePassword paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
            
            self->_info.hidden = YES;
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            self->_info.hidden = NO;
            self->_info.text = dic[@"info"];
        }
        
    } faild:^(id responseObject) {
        sender.enabled = YES;
        self->_info.hidden = NO;
        self->_info.text = @"网络错误，请检查您的网络权限";
//                _inforLable.text = @"网络错误";
    }];

    
}

- (IBAction)forgetAction:(UIButton *)sender {
    
   NSString *tel = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"phone"];
    
    ProofPswViewController *findVC = [[ProofPswViewController alloc]init];
    findVC.tel = tel;
    [self.navigationController pushViewController:findVC animated:YES];
    
}
@end
