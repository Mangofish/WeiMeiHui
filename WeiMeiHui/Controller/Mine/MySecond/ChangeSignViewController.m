//
//  ChangeSignViewController.m
//  WeiMeiHui
//
//  Created by Mac on 2017/6/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ChangeSignViewController.h"

@interface ChangeSignViewController ()

@property (weak, nonatomic) IBOutlet UITextView *signTF;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@end

@implementation ChangeSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backTop.constant = SafeAreaTopHeight;
    self.titleTop.constant = SafeAreaTopHeight;
    self.topViewHeight.constant = SafeAreaHeight;
    self.rightTop.constant = SafeAreaTopHeight;
    
    
    [ZZLimitInputManager limitInputView:self.signTF maxLength:20];
}



- (IBAction)popAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveAction:(UIButton *)sender {
    
    self.changeComplete(_signTF.text);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
