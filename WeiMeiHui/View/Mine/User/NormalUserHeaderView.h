//
//  UserHeaderView.h
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHeader.h"

@interface NormalUserHeaderView : UIView
@property(strong,nonatomic)UserHeader *homeCellViewModel;

+(instancetype)userHeaderViewWithFrame:(CGRect)frame;

+(instancetype)userHeadView;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@end
