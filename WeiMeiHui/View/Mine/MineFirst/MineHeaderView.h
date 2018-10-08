//
//  MineHeaderView.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/3/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiUserInfo.h"

@protocol MineHeaderViewDelegate <NSObject>

- (void)didClickIconBtn;
- (void)didClickMenuIndex:(NSInteger)index;
- (void)didClickFans;

@end

@interface MineHeaderView : UIView

@property (strong,nonatomic) WeiUserInfo *user;

@property (strong,nonatomic) WeiUserInfo *authorUser;

@property (weak, nonatomic) IBOutlet UILabel *redLab;

+(instancetype)headerViewWithFrame:(CGRect)frame;

+(instancetype)headerViewLoginWithFrame:(CGRect)frame;
+(instancetype)headerViewNotLogWithFrame:(CGRect)frame;


@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *centLab;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak,nonatomic) id <MineHeaderViewDelegate>delegate;

@end
