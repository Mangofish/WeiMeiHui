//
//  UMClickViewController.m
//  WeiMeiHui
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "UMClickViewController.h"
#import "UMMobClick/MobClick.h"

@interface UMClickViewController ()

@end

@implementation UMClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
