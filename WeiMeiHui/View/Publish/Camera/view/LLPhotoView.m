//
//  LLPhotoView.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "LLPhotoView.h"



@implementation LLPhotoView{
    UIImageView *_player;
    
}

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSData *)photoUrl{
    if (self = [super initWithFrame:frame]) {
        _photoUrl = photoUrl;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    _player = [[UIImageView alloc]initWithFrame:self.bounds];
    _player.image = [UIImage imageWithData:_photoUrl];
    [self addSubview:_player];
}

@end
