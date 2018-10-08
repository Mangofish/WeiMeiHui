//
//  UITabBar+Redpoint.h
//  WeiMeiHui
//
//  Created by apple on 2017/9/21.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Redpoint)

- (void)showBadgeOnItmIndex:(int)index tabbarNum:(int)tabbarNum;
-(void)hideBadgeOnItemIndex:(int)index;

@end
