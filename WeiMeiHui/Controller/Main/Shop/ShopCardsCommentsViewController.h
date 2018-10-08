//
//  ShopCardsCommentsViewController.h
//  WeiMeiHui
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ShopCardsCommentsViewController : UIViewController

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSDictionary *authorDic;

@property (nonatomic, copy) void(^selectComplete)(NSDictionary *obj);

@end
