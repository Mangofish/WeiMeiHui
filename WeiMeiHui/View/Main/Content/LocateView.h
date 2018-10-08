//
//  LocateView.h
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiContent.h"

@protocol LocateViewDelegate <NSObject>

- (void)didSelectedShopBtn:(UIButton *)sender;
- (void)didSelectedDelBtn:(UIButton *)sender;

@end

@interface LocateView : UIView

@property(strong,nonatomic)WeiContent *homeCellViewModel;
@property(strong,nonatomic)UIButton *positionBtn;
@property(strong,nonatomic)UILabel *positionLab;
@property(strong,nonatomic)UIButton *delBtn;

@property (nonatomic, weak) id<LocateViewDelegate> delegate;
@end
