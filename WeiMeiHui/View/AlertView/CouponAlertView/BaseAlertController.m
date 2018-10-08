//
//  AlertViewController.m
//  Test
//
//  Created by GiaJiang on 2017/8/10.
//  Copyright © 2017年 Gia. All rights reserved.
//

#import "BaseAlertController.h"
#import "CouponAlertView.h"

@interface BaseAlertController ()<CouponAlertViewDelegate>

@end

@implementation BaseAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - AlertPresentationContentControllerProtocol
- (PresentationStyle)alertPresentationContentControllerStyle {
    return PresentationStyleActionSheet;
}

- (NSTimeInterval)alertPresentationContentControllerTransitionDuration {
    return 0.5;
}

- (CGFloat)alertPresentationContentControllerVisualBgAlpha {
    return 0.6;
}

- (UIView *)alertPresentationContentControllerContentView {
    CouponAlertView *view = [CouponAlertView couponAlertviewWithFrame:CGRectMake(0, 0, kWidth, kHeight*2/3)];
    view.dataAry = self.dataAry;
    view.delegate = self;
    return view;
}

#pragma mark - 代理方法
- (void)couponAlertViewshouldDismiss{
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)couponAlertViewdidSelectAtIndex:(NSUInteger)index{
    self.selectComplete(index);
//     [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
