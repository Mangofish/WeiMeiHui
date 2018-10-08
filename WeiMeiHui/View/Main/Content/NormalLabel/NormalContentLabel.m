//
//  NormalContentLabel.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "NormalContentLabel.h"

@implementation NormalContentLabel

-(instancetype)initWithFrame:(CGRect)frame{
   self =  [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = FontColor;
        self.numberOfLines = 2;
        
    }
    return self;
}

@end
