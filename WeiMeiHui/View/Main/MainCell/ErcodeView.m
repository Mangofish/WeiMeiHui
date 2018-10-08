//
//  ErcodeView.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ErcodeView.h"

@implementation ErcodeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"ErcodeView" owner:self options:nil][0];
        self.frame= frame;
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

@end
