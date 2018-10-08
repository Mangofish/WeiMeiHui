//
//  WeiBottomView.h
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiContent.h"

@protocol WeiBottomViewDelegate <NSObject>

- (void)chooseZan:(UIButton *)sender;
- (void)chooseComment:(UIButton *)sender;
- (void)chooseMessege:(UIButton *)sender;

@end

@interface WeiBottomView : UIView

@property(strong,nonatomic)WeiContent *homeCellViewModel;

@property(strong,nonatomic) UIButton *btnForwarding;
@property(strong,nonatomic) UIButton *btnComments;
@property(strong,nonatomic) UIButton *btnPraise;

@property(strong,nonatomic) UIButton *realBtn;

@property(weak,nonatomic)id <WeiBottomViewDelegate>delegate;
@end
