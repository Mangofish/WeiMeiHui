//
//  AllRangeViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AllRangeViewController.h"

@interface AllRangeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewTop;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *pubBtn;

@property (strong, nonatomic)  UIButton *selectedBtn;

@end

@implementation AllRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavView];
    self.selectedBtn = [self.view viewWithTag:1];
}

- (void)configNavView {
    
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
    
    [_pubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(24);
        make.right.mas_equalTo(self.view.mas_right).offset(-Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    
}

- (IBAction)chooseRange:(UIButton *)sender {
    sender.selected = YES;
    self.selectedBtn.selected = NO;
    self.selectedBtn = sender;
    
}

- (IBAction)doneAction:(UIButton *)sender {
    
    NSString *str = [NSString stringWithFormat:@"%li",(long)self.selectedBtn.tag];
    NSString *name = @"";
    switch (self.selectedBtn.tag) {
        case 1:
            name = @"公开";
            break;
        case 2:
            name = @"手艺人";
            break;
        case 3:
            name = @"同城";
            break;
        case 4:
            name = @"普通用户";
            break;
        case 5:
            name = @"关注我";
            break;
          
        default:
            break;
    }
    
    self.selectComplete(str, name);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)popAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
