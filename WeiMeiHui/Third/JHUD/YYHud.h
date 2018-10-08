//
//  YYHud.h
//  WeiMeiHui
//
//  Created by apple on 2017/7/26.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHUD.h"

@interface YYHud : NSObject

//Public Methods

@property (nonatomic, copy) NSString *message;

-(void)showInView:(UIView *)view;
-(void)dismiss;

@end
