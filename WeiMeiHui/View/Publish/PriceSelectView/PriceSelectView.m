//
//  PriceSelectView.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PriceSelectView.h"

@interface PriceSelectView ()<GWLCustomSliderNewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *minPriceTF;

@property (weak, nonatomic) IBOutlet UITextField *maxPriceTF;

@end

@implementation PriceSelectView
+ (instancetype)priceSelectView{
    
    PriceSelectView *instance = [[NSBundle mainBundle] loadNibNamed:@"PriceSelectView" owner:nil options:nil][1];
    [ZZLimitInputManager limitInputView:instance.maxPriceTF maxLength:9];
    [ZZLimitInputManager limitInputView:instance.minPriceTF maxLength:9];
    return instance;
}

- (IBAction)sureAction:(UIButton *)sender {
    
    [self.delegate chooseMax:self.maxPriceTF.text min:self.minPriceTF.text];
}

- (void)setTitleAry:(NSArray *)titleAry{
    
    GWLCustomSliderNew *customSlider = [GWLCustomSliderNew customSliderWithDefalutMinValue:_minprice withDefalutMaxValue:_maxprice andMinMaxCanSame:NO];
    customSlider.frame = CGRectMake(14, 60, kWidth-28, 50);
    customSlider.delegate = self;
    [self addSubview:customSlider];
    self.customSlider = customSlider;
    [self addSubview:_customSlider];
    
}


- (void)customSliderValueChanged:(GWLCustomSliderNew *)slider minValue:(NSString *)minValue maxValue:(NSString *)maxValue {
    
    self.price.text = [NSString stringWithFormat:@"%@元-%@元",minValue,maxValue];
    
    self.minprice = [minValue integerValue];
    self.maxprice = [maxValue integerValue];
}


@end
