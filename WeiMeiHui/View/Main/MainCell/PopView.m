//
//  PopView.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PopView.h"

@implementation PopView

+(instancetype)popView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"PopView" owner:nil options:nil][0];
    
}

- (IBAction)cameraAction:(UIButton *)sender {
    [self.delegate didClickMenuIndex:0];
}

- (IBAction)photoAction:(UIButton *)sender {
    [self.delegate didClickMenuIndex:1];
}

@end
