//
//  CircleView.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircleProgress.h"
#import "XLCircle.h"

@implementation XLCircleProgress
{
    XLCircle* _circle;
    UILabel *_percentLabel;
    UIView * _backView;
    UILabel * _infor;
    UIButton *cancelBtn;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


-(void)initUI
{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [self addSubview:_backView];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.2;
    
    
    
    float lineWidth = 0.1*self.bounds.size.width;
    _percentLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _percentLabel.textColor = [UIColor whiteColor];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    _percentLabel.font = [UIFont boldSystemFontOfSize:18];
    _percentLabel.text = @"0%";
    [self addSubview:_percentLabel];
    
    _circle = [[XLCircle alloc] initWithFrame:self.bounds lineWidth:lineWidth];
    [self addSubview:_circle];
    
    _infor = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight/2+72, kWidth, 20)];
    _infor.textColor = [UIColor whiteColor];
    _infor.textAlignment = NSTextAlignmentCenter;
    _infor.font = [UIFont boldSystemFontOfSize:18];
    _infor.text = @"正在上传中,请勿退出";
    [self addSubview:_infor];
    
    cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-60, kHeight/2+104, 120, 32)];
    cancelBtn.backgroundColor = MainColor;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancelBtn];
}

#pragma mark -
- (void)cancelAction{
    
    [self.delegate cancelUploadAction];
    
}

#pragma mark Setter方法
-(void)setProgress:(float)progress
{
    _progress = progress;
    _circle.progress = progress;
    _percentLabel.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
}

@end
