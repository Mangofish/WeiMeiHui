//
//  AllShopViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllShopViewController : UMClickViewController

@property (nonatomic, copy) void(^selectComplete)(NSString * aShopID,NSString * aShopName);

@property (nonatomic, copy) NSString *alredyShopID;

@end
