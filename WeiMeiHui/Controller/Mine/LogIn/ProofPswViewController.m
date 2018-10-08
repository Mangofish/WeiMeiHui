//
//  ProofPswViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/7/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ProofPswViewController.h"
#import "UIButton+CountDown.h"
#import "FindPSWViewController.h"

@interface ProofPswViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *codesBTn;
@property (weak, nonatomic) IBOutlet UILabel *inforLable;
@property (weak, nonatomic) IBOutlet UIView *lineOne;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoTitleLab;
@property (weak, nonatomic) IBOutlet UITextField *code;

@end

@implementation ProofPswViewController

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

    [self.code setInputAccessoryView:topView];
    
    _backBtn.frame = CGRectMake(0, SafeAreaTopHeight, 40, 40);

    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(35);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY).offset(0);
    }];
    
    
    
    [_infoTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.backBtn.mas_bottom).offset(40);
    }];
    
    NSString *temp = [self.tel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    self.infoTitleLab.text = [NSString stringWithFormat:@"%@",temp];

    UIButton *button2 = [_code valueForKey:@"_clearButton"];
    [button2 setImage:[UIImage imageNamed:@"全删"] forState:UIControlStateNormal];
    
    _code.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.code.delegate = self;
    
    [_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80-10-65);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.infoTitleLab.mas_bottom).offset(Space);
    }];
    
    [_codesBTn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.centerY.mas_equalTo(self.code.mas_centerY).offset(0);
    }];
    
    [_lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.code.mas_bottom).offset(1);
    }];
    
   
    [_inforLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineOne.mas_bottom).offset(Space);
    }];
    
    [_finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-80);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.top.mas_equalTo(self.lineOne.mas_bottom).offset(40);
    }];
    
    _finishBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:167/255.0 blue:173/255.0 alpha:1];
    [_finishBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:222/255.0 blue:225/255.0 alpha:1] forState:UIControlStateNormal];
    _finishBtn.enabled = NO;
    
    _finishBtn.layer.cornerRadius = 20;
    _finishBtn.layer.masksToBounds = YES;
    
    
}



- (void)doneWithIt{
    [self.view endEditing:YES];
    
}

#pragma -mark- 验证码按钮生效后的时间计时。
- (void)countDown {
    
    [self.codesBTn startWithTime:COUNTS title:@"重新获取" countDownTitle:@"s后获取" mainColor:MainColor countColor:[UIColor clearColor]];
}


- (IBAction)protocolAction:(UIButton *)sender {
    
    _inforLable.text = @"";
    [self countDown];
    //请求验证码
    NSString *url = [PublicMethods dataTojsonString:@{@"phone":_tel,@"request_time":[self convertTimeSp]}];
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

- (IBAction)popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)proofAction:(UIButton *)sender {
    
    NSString *url = [PublicMethods dataTojsonString:@{@"phone":_tel,@"type":@"3",@"code":_code.text}];
    
    
    [YYNet POST:ProofCode paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"success"] boolValue]) {
          
            FindPSWViewController *findVC = [[FindPSWViewController alloc]init];
            findVC.tel = self.tel;
            [self.navigationController pushViewController:findVC animated:YES];
            return ;
            
        }else{
            
            self->_inforLable.text = dic[@"info"];
            
        }
        
        
    } faild:^(id responseObject) {
        
//        NSDictionary *dic = [solveJsonData changeType:responseObject];
        self->_inforLable.text = @"网络错误,请检查您的网络";
        
    }];

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"电话号码%@，range：%@",string,NSStringFromRange(range));
    
    if ( (range.location-range.length) == 5 ) {
        _finishBtn.backgroundColor = MainColor;
        [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishBtn.enabled = YES;
        
    }else{
        
        _finishBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:167/255.0 blue:173/255.0 alpha:1];
        [_finishBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:222/255.0 blue:225/255.0 alpha:1] forState:UIControlStateNormal];
        _finishBtn.enabled = NO;
        
    }
    
    return YES;
    
    
}

- (NSString *)convertTimeSp{
    
    NSDate* date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
}


@end
