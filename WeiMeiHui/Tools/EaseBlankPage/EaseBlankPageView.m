//
//  EaseBlankPageView.m
//  Blossom
//
//  Created by wujunyang on 15/9/21.
//  Copyright © 2015年 wujunyang. All rights reserved.
//

#import "EaseBlankPageView.h"

@implementation EaseBlankPageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configWithType:(EaseBlankPageType)blankPageType hasTitle:(NSString *)title hasImageName:(NSString *)imgName hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block{
    
    if (hasData) {
        [self removeFromSuperview];
        return;
    }
    self.alpha = 1.0;
    //    图片
    if (!_monkeyView) {
        _monkeyView = [[UIImageView alloc] init];
        [self addSubview:_monkeyView];
        
    }
    //    文字
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    
    //    布局
    [_monkeyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(30));
        make.left.equalTo(@(kWidth/2-60));
        make.height.width.mas_equalTo(120);
    }];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_monkeyView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    _reloadButtonBlock = nil;
    
    if (!_reloadButton) {
        _reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_reloadButton setTitle:@"关注更多有趣的人" forState:UIControlStateNormal];
        _reloadButton.adjustsImageWhenHighlighted = YES;
        _reloadButton.backgroundColor = MJRefreshColor(42, 222, 177);
        [_reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _reloadButton.layer.cornerRadius = 5;
        _reloadButton.layer.masksToBounds= YES;
        [self addSubview:_reloadButton];
        [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_tipLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(kWidth - 20, 40));
        }];
    }
    _reloadButton.hidden = NO;
    _reloadButtonBlock = block;
    
    if (hasError) {
        //        加载失败

        [_monkeyView setImage:[UIImage imageNamed:imgName]];
        _tipLabel.text = title;
        
        if (blankPageType==EaseBlankPageTypeMaterialScheduling) {
            _reloadButton.hidden=YES;
        }
        
    }else{
        //        空白数据
        if (_reloadButton) {
            _reloadButton.hidden = NO;
        }
        NSString *imageName, *tipStr;
        switch (blankPageType) {
            case EaseBlankPageTypeProject:
            {
                imageName = imgName;
                tipStr = title;
            }
                break;
            case EaseBlankPageTypeNoButton:
            {
                imageName = imgName;
                tipStr = title;
                if (_reloadButton) {
                    _reloadButton.hidden = YES;
                }
            }
                break;
            default://其它页面（这里没有提到的页面，都属于其它）
            {
                imageName = imgName;
                tipStr = title;
            }
                break;
        }
        [_monkeyView setImage:[UIImage imageNamed:imageName]];
        _tipLabel.text = tipStr;
    }
}

- (void)reloadButtonClicked:(id)sender{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_reloadButtonBlock) {
            self->_reloadButtonBlock(sender);
        }
    });
}
@end
