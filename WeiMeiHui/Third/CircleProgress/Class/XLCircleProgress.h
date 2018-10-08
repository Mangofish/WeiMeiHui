//
//  CircleView.h
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLCircleProgressDelegate <NSObject>

- (void)cancelUploadAction;

@end

@interface XLCircleProgress : UIView
//百分比
@property (assign,nonatomic) float progress;

@property (weak,nonatomic) id<XLCircleProgressDelegate> delegate;
@end
