//
//  JFCityCollectionViewCell.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFCityCollectionViewCell.h"

#define JFRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]

@interface JFCityCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation JFCityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.label = label;
        
        
        
    }
    return self;    
}

/// 设置collectionView cell的border
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = JFRGBAColor(242, 240, 240, 1).CGColor;
    self.layer.masksToBounds = YES;
}

- (void)setTitle:(NSString *)title {
    self.label.text = title;
    
    NSString *currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:WEICurrentCity];
    NSString *locationCity = [[NSUserDefaults standardUserDefaults] objectForKey:WEILOCATION];
    
    if ([title isEqualToString:currentCity]) {
        self.label.backgroundColor = MainColor;
        self.label.textColor = [UIColor whiteColor];
        
        if ([title isEqualToString:locationCity]) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(Space, 0, 20, 39)];
            [btn setImage:[UIImage imageNamed:@"定位2白"] forState:UIControlStateNormal];
            [self addSubview:btn];
        }
        
    }
    
    if (![title isEqualToString:currentCity] && ([title isEqualToString:locationCity])) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(Space, 0, 20, 39)];
        [btn setImage:[UIImage imageNamed:@"定位2红"] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    
    
}

- (void)setTextColor:(UIColor *)textColor{
    
    _textColor = textColor;
    _label.textColor = textColor;
    _label.backgroundColor = MainColor;
}
@end
