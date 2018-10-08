//
//  UITabBar+Redpoint.m
//  WeiMeiHui
//
//  Created by apple on 2017/9/21.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "UITabBar+Redpoint.h"

@implementation UITabBar (Redpoint)

/**
 tabbar显示小红点
 
 @param index 第几个控制器显示，从0开始算起
 @param tabbarNum tabbarcontroller一共多少个控制器
 */

- (void)showBadgeOnItmIndex:(int)index tabbarNum:(int)tabbarNum{
    [self removeBadgeOnItemIndex:index]; //label为小红点，并设置label属性
    UILabel *label = [[UILabel alloc]init];
    label.tag = 1000+index;
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame; //计算小红点的X值，根据第index控制器，小红点在每个tabbar按钮的中部偏移0.1，即是每个按钮宽度的0.6倍
    CGFloat percentX = (index+0.6);
    CGFloat tabBarButtonW = CGRectGetWidth(tabFrame)/tabbarNum;
    CGFloat x = percentX*tabBarButtonW;
    CGFloat y = 0.1*CGRectGetHeight(tabFrame); //10为小红点的高度和宽度
    label.frame = CGRectMake(x, y, 8, 8);
    [self addSubview:label];
    //把小红点移到最顶层
    [self bringSubviewToFront:label];
}

/** 隐藏红点
 @param index 第几个控制器隐藏，从0开始算起
 */
-(void)hideBadgeOnItemIndex:(int)index{
    
    [self removeBadgeOnItemIndex:index];
}

/** 移除控件
 @param index 第几个控制器要移除控件，从0开始算起
 */
- (void)removeBadgeOnItemIndex:(int)index{
    
    for (UIView*subView in self.subviews){
        if (subView.tag == 1000+index) {
            [subView removeFromSuperview];
        }
    }
}



@end
