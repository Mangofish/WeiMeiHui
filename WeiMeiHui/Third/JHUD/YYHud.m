//
//  YYHud.m
//  WeiMeiHui
//
//  Created by apple on 2017/7/26.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "YYHud.h"

@interface YYHud ()

@property (strong, nonatomic) JHUD *hudView;

@end

@implementation YYHud

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}


-(void)showInView:(UIView *)view{
    
    
    [self.hudView showAtView:view hudType:JHUDLoadingTypeGifImage];
    
}

- (JHUD *)hudView{
    
    if (_hudView) {
        return _hudView;
    }
    
    _hudView = [[JHUD alloc]initWithFrame:CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"smallCube" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    _hudView.gifImageData = data;
    _hudView.indicatorViewSize = CGSizeMake(110, 84); // Maybe you can try to use (100,250);😂
    _hudView.messageLabel.text = self.message;
    
    return _hudView;
}

-(void)dismiss{
    
    [JHUD hideForView:self.hudView.superview];
    
}
@end
