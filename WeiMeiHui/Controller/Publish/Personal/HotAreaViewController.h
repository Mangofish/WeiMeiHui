//
//  HotAreaViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotAreaViewController : UMClickViewController

@property (nonatomic, strong) NSArray *categoryData;
@property (nonatomic, strong) NSArray *areaData;

@property (nonatomic, copy) void(^chooseComplete)(NSString * aName,NSString *areaid,NSString *cityid);

@end
