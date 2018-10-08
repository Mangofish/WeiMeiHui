//
//  TimeStatusView.m
//  ocCrazy
//
//  Created by 宋学谦 on 2016/12/10.
//  Copyright © 2016年 dukai. All rights reserved.
//

#import "TimeStatusView.h"

@implementation TimeStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;

//        self.picImage = [[UIImageView alloc] init];
//        self.picImage.backgroundColor = [UIColor whiteColor];
//        self.picImage.userInteractionEnabled = NO;
//        [self addSubview:self.picImage];
        
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = LightFontColor;
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.userInteractionEnabled = NO;
        [self addSubview:self.timeLabel];
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.font = [UIFont systemFontOfSize:10];
        self.statusLabel.textColor = LightFontColor;
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.userInteractionEnabled = NO;
        [self addSubview:self.statusLabel];
        
        
    }
    return self;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.picImage.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.timeLabel.frame = CGRectMake(10, 9, SCREEN_WIDTH / 4, 15);
    self.statusLabel.frame = CGRectMake(10, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height, SCREEN_WIDTH / 4, 15);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
