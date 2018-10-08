//
//  AlertView.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

+(instancetype)alertViewWithFrame:(CGRect)frame{
    AlertView *alert = [[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:self options:nil][0];
    alert.frame = frame;
    return alert;
}


- (IBAction)sureAction:(UIButton *)sender {
    [self.delegate didClickMenuIndex:1];
}

- (IBAction)cancelAction:(UIButton *)sender {
    
    [self.delegate didClickMenuIndex:0];
}
@end
