//
//  AlertViewController.h
//  Test
//
//  Created by GiaJiang on 2017/8/10.
//  Copyright © 2017年 Gia. All rights reserved.
//

#import "BasePresentationContentController.h"

@interface BaseAlertController : BasePresentationContentController

@property (nonatomic, copy) NSArray *dataAry;

@property (nonatomic, copy) void(^selectComplete)(NSUInteger index);

- (void)couponAlertViewshouldDismiss;
@end
