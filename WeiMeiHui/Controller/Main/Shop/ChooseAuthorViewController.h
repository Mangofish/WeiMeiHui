//
//  ChooseAuthorViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAuthorViewController : UIViewController

@property (nonatomic, copy) NSArray *dataAry;
@property (nonatomic, copy) void(^selectComplete)(NSDictionary *obj);
@end
