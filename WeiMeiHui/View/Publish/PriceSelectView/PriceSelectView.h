//
//  PriceSelectView.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GWLCustomSliderNew.h"


@protocol PriceSelectViewDelegate <NSObject>

- (void)chooseMax:(NSString *)maxValue min:(NSString *)minValue;

@end

@interface PriceSelectView : UIView


@property (weak, nonatomic) IBOutlet UILabel *price;

+(instancetype)priceSelectView;

@property (assign, nonatomic)  NSInteger minprice;
@property (assign, nonatomic)  NSInteger maxprice;

@property (copy, nonatomic)  NSArray * titleAry;

@property (nonatomic, weak) id<PriceSelectViewDelegate> delegate;

@property(nonatomic, strong) GWLCustomSliderNew *customSlider;

@end
