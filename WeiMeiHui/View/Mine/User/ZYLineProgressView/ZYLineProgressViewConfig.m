//
//  ZYLineProgressViewConfig.m
//  ZYLineProgressViewDemo
//
//  GitHub https://github.com/ripperhe
//  Created by ripper on 2017/3/1.
//  Copyright © 2017年 ripper. All rights reserved.
//

#import "ZYLineProgressViewConfig.h"

@implementation ZYLineProgressViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.capType = ZYLineProgressViewCapTypeRound;
        self.backLineColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:25/255.0 alpha:1];;
        self.progressLineColor = MainColor;
        
        self.isShowDot = NO;
        self.dotSpace = 1;
        self.dotColor = [UIColor whiteColor];
    }
    return self;
}

@end
