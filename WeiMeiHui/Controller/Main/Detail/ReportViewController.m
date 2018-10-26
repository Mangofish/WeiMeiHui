//
//  ReportViewController.m
//  WeiMeiHui
//
//  Created by Mac on 17/4/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ReportViewController.h"
#import "ZYKeyboardUtil.h"
#import "WeiUserInfo.h"

@interface ReportViewController ()

{
    UIButton *_selectedBtn;
 
}

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reportViewTop;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tabBarController.tabBar.hidden= YES;
    
    //在弹出的键盘上方增加一个按钮，用于关闭弹出的键盘。
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(doneWithIt) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"确定" forState:(UIControlStateNormal)];
    btn.backgroundColor = MainColor;
    //[btn setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateNormal];//可以设置一个图标。
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [self.textView setInputAccessoryView:topView];
    
    
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:5];
    __weak ReportViewController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.textView, nil];
    }];
    
    self.reportViewTop.constant = SafeAreaTopHeight;
}

- (void) doneWithIt{
    [self.textView resignFirstResponder];
}

- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)reasonAction:(UIButton *)sender {
    
    
    if (sender.selected) {
        return;
    }
    _selectedBtn.selected = NO;
    sender.selected = !sender.selected;
    _selectedBtn = sender;
    
}

- (IBAction)sendAction:(UIButton *)sender {
    
    if (!_selectedBtn) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"您还没有选择举报原因" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        return;

    }
    
    NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
//    WeiUserInfo * user = [WeiUserInfo weiUserInfoWithDict:userDict];
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":[userDict  objectForKey:@"uuid"],@"id":_ID,@"reason":_selectedBtn.currentTitle,@"content":_textView.text}];
    
    
    [YYNet POST:Report paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        if ([dic[@"success"] boolValue]) {
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"success"]];
            toast.toastType = FFToastTypeSuccess;
            toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
            [toast show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } faild:^(id responseObject) {
        
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"网络连接失败" iconImage:[UIImage imageNamed:@"warning"]];
        toast.toastType = FFToastTypeWarning;
        toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
        [toast show];
        
    }];
    
}

@end
