//
//  AllRangeViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllRangeViewController : UMClickViewController

@property (nonatomic, copy) void(^selectComplete)(NSString * aRangeID,NSString * aRangeName);

@end
