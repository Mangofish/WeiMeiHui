//
//  WeiContentImageView.h
//  WeiMeiHui
//
//  Created by apple on 2018/1/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiContent.h"

@interface WeiContentImageView : UIView

@property(strong,nonatomic)NSMutableArray *urlArray;
@property(strong,nonatomic)WeiContent *homeCellViewModel;

/**
 *  获取高度
 */
+(float)getContentImageViewHeight:(NSArray *)data;

@end
