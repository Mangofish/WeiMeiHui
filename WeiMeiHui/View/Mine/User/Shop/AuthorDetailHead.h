//
//  AuthorDetailHead.h
//  WeiMeiHui
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

@interface AuthorDetailHead : UIView

+(instancetype)authorDetailHead;
+(instancetype)authorDetailHeadMine;

@property (copy, nonatomic) NSArray *tagAry;
@property (assign, nonatomic) float cellHeight;
@property(strong,nonatomic)ShopModel *model;
@property(strong,nonatomic)ShopModel *modelGoods;
@property(strong,nonatomic)ShopModel *modelMine;
@end
