//
//  MainTitleView.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MainTitleView.h"

@interface MainTitleView ()






@end

@implementation MainTitleView

+(instancetype)mainTitleView{
    
    MainTitleView *instance =  [[NSBundle mainBundle] loadNibNamed:@"MainTitleView" owner:nil options:nil][1];
    instance.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    instance.backView.layer.cornerRadius = 14;
    instance.backView.layer.masksToBounds = YES;
    
    instance.locationBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    instance.locationBtn.layer.cornerRadius = 14;
    instance.locationBtn.layer.masksToBounds = YES;
    return instance;
}
- (IBAction)pubAction:(UIButton *)sender {
    [self.delegate chooseCamera:sender];
}

- (IBAction)location:(UIButton *)sender {
    [self.delegate chooseLocation:sender];
}

- (IBAction)searchAction:(UIButton *)sender {
    [self.delegate chooseSearch:sender];
}

- (IBAction)menuAction:(UIButton *)sender {
    [self.delegate menuAlertAction:sender];
}

@end
