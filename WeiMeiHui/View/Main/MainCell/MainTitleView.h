//
//  MainTitleView.h
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainTitleViewDelegate <NSObject>

- (void)chooseCamera:(UIButton *)sender;
- (void)chooseLocation:(UIButton *)sender;
- (void)chooseSearch:(UIButton *)sender;
- (void)menuAlertAction:(UIButton *)sender;

@end

@interface MainTitleView : UIView
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *localImg;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *realSearchBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightMenuBtn;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic)  id <MainTitleViewDelegate> delegate;
+(instancetype)mainTitleView;


@end
