//
//  GWLCustomSliderNew.m
//  GWLCustomSliderNew.m
//
//  Created by 高万里 on 15/6/10.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "GWLCustomSliderNew.h"
#import "UIView+Add.h"

#define kMARGIN     10  // 边距

#define slideY     30  //距离上面的距离

#define slideScale     3  //倍数

#define kCOLORBLUE  ([UIColor colorWithRed:69/255.0f green:135/255.0f blue:195/255.0f alpha:1.0])

@interface GWLCustomSliderNew ()

@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)NSInteger defalutMinValue;
@property(nonatomic,assign)NSInteger defalutMaxValue;
/**最小值和最大值是否可以一样*/
@property(nonatomic,assign)BOOL minMaxCanSame;

@property(nonatomic,weak)UIView *sliderView;
@property(nonatomic,weak)UILabel *backgroundIndicatorLabel;
@property(nonatomic,weak)UILabel *indicatorLabel;
@property(nonatomic,weak)UIButton *minSliderButton;
@property(nonatomic,weak)UIButton *maxSliderButton;

@property(nonatomic,weak)UILabel *minLable;
@property(nonatomic,weak)UILabel *maxlable;

/**标题Label数组*/
@property(nonatomic,strong)NSMutableArray *titleLabelArray;
/**一个刻度的长度*/
@property(nonatomic,assign)CGFloat scale;
/**三倍距离*/
@property(nonatomic,assign)CGFloat threeScale;

/**完成了一次布局*/
@property(nonatomic,assign)BOOL layoutOnceDone;

@end

@implementation GWLCustomSliderNew

+ (instancetype)customSliderWithDefalutMinValue:(float)defalutMinValue withDefalutMaxValue:(float)defalutMaxValue andMinMaxCanSame:(BOOL)minMaxCanSame{
    return [[self alloc]initWithDefalutMinValue:defalutMinValue withDefalutMaxValue:defalutMaxValue andMinMaxCanSame:minMaxCanSame];
}

- (instancetype)initWithDefalutMinValue:(float)defalutMinValue withDefalutMaxValue:(float)defalutMaxValue andMinMaxCanSame:(BOOL)minMaxCanSame {
    if (self = [super init]) {
        [self makeSubviews];
        self.backgroundColor = [UIColor whiteColor];
        _defalutMinValue = defalutMinValue;
        _defalutMaxValue = defalutMaxValue;
        _minMaxCanSame = minMaxCanSame;
    }
    return self;
}

- (void)makeSubviews {
    
    UIView *sliderView = [[UIView alloc]init];
    [self addSubview:sliderView];
    self.sliderView = sliderView;
    
    UILabel *backgroundIndicatorLabel = [[UILabel alloc]init];
    backgroundIndicatorLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:backgroundIndicatorLabel];
    self.backgroundIndicatorLabel = backgroundIndicatorLabel;
    
    UILabel *indicatorLabel = [[UILabel alloc]init];
    indicatorLabel.backgroundColor = MainColor;
    [self addSubview:indicatorLabel];
    self.indicatorLabel = indicatorLabel;
    
    UIButton *minSliderButton = [[UIButton alloc]init];
    [minSliderButton setImage:[UIImage imageNamed:@"圆角矩形3"] forState:UIControlStateNormal];
    [minSliderButton setImage:[UIImage imageNamed:@"圆角矩形3"] forState:UIControlStateHighlighted];
    [minSliderButton setImage:[UIImage imageNamed:@"圆角矩形3"] forState:UIControlStateSelected];
    UIPanGestureRecognizer *minSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMinSliderButton:)];
    [minSliderButton addGestureRecognizer:minSliderButtonPanGestureRecognizer];
    [self addSubview:minSliderButton];
    [minSliderButton setMultipleTouchEnabled:YES];
    self.minSliderButton = minSliderButton;
    
    UIButton *maxSliderButton = [[UIButton alloc]init];
    [maxSliderButton setImage:[UIImage imageNamed:@"圆角矩形3"] forState:UIControlStateNormal];
    [maxSliderButton setImage:[UIImage imageNamed:@"圆角矩形3"] forState:UIControlStateHighlighted];
    [maxSliderButton setImage:[UIImage imageNamed:@"圆角矩形3"] forState:UIControlStateSelected];
    UIPanGestureRecognizer *maxSliderButtonPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMaxSliderButton:)];
    [maxSliderButton addGestureRecognizer:maxSliderButtonPanGestureRecognizer];
    [self addSubview:maxSliderButton];
    [maxSliderButton setMultipleTouchEnabled:YES];
    [maxSliderButton setUserInteractionEnabled:YES];
    self.maxSliderButton = maxSliderButton;
    
    UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(kMARGIN, 38, 100, 30)];
    leftLab.textColor = MJRefreshColor(153, 153, 153);
    leftLab.font = [UIFont systemFontOfSize:12];
    leftLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:leftLab];
    self.minLable = leftLab;
    
    UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-kMARGIN*2-50, 38, 50, 30)];
    rightLab.textColor = MJRefreshColor(153, 153, 153);
    rightLab.font = [UIFont systemFontOfSize:12];
    rightLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:rightLab];
    self.maxlable = rightLab;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_layoutOnceDone) {
        return;
    }
    CGFloat contentW = self.width-2*kMARGIN; // 内容宽度
    CGFloat titleLabelW = contentW/(_defalutMaxValue-_defalutMinValue);
    
    self.minLable.text = [NSString stringWithFormat:@"%li",(long)_defalutMinValue];
    self.maxlable.text = [NSString stringWithFormat:@"%li",(long)_defalutMaxValue];
    
    self.scale = titleLabelW;// 每个刻度的宽度
    self.threeScale = self.scale*slideScale*_defalutMinValue;
    
    _backgroundIndicatorLabel.frame = CGRectMake(kMARGIN,slideY, contentW-kMARGIN*2, 4);
    _backgroundIndicatorLabel.layer.cornerRadius = _backgroundIndicatorLabel.height*0.5;
    _backgroundIndicatorLabel.layer.masksToBounds = YES;
    
    _indicatorLabel.frame = _backgroundIndicatorLabel.frame;
    _indicatorLabel.size = _backgroundIndicatorLabel.size;
    _indicatorLabel.layer.cornerRadius = _indicatorLabel.height*0.5;
    _indicatorLabel.layer.masksToBounds = YES;
    
    CGFloat sliderViewH = 0;
    if (_minSliderButton.currentImage != nil) {
        sliderViewH = _minSliderButton.currentImage.size.height*(titleLabelW/_minSliderButton.currentImage.size.width);
    }
    _sliderView.frame = CGRectMake(kMARGIN, 0, contentW, sliderViewH);
    
     _minSliderButton.frame = CGRectMake(kMARGIN-12, 8, 24, 22);
    //        最小值
    CGFloat minX = self.minSliderButton.X-kMARGIN+12;
    NSInteger minValue = _defalutMinValue + minX/_scale;
    //        最大值
    NSInteger maxValue = slideScale*minValue;
    
    //        值区间
    CGFloat width = (maxValue -minValue)*self.scale;
    
    CGFloat maxX = self.minSliderButton.X +width;
    
    //        设置右侧三倍距离
    self.maxSliderButton.X = maxX-kMARGIN-12;
    
    _maxSliderButton.frame = CGRectMake(maxX, 8, 24, 22);
    
    [self configureIndicatorLableXW];
    
//    [self valueChanged];
}

/**minSlider拖动事件*/
- (void)panMinSliderButton:(UIPanGestureRecognizer *)pan {
    CGPoint panPoint = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    

    CGFloat toX = self.minSliderButton.X + panPoint.x;
    CGFloat panMaxX = CGRectGetMaxX(_backgroundIndicatorLabel.frame)-12;
   
    if ( toX > kMARGIN-12 && toX < panMaxX) {
        self.minSliderButton.X = toX;
        
//        对应数值
//        最小值
        CGFloat minX = self.minSliderButton.X-kMARGIN+12;
        NSInteger minValue = _defalutMinValue + minX/_scale;
//        最大值
        NSInteger maxValue = slideScale*minValue;
        
//        值区间
        CGFloat width = (maxValue -minValue)*self.scale;
        self.threeScale = width;
        
        CGFloat maxX = self.minSliderButton.X +width;
        
//        设置右侧三倍距离
        self.maxSliderButton.X = maxX;
        
        if (self.maxSliderButton.X > panMaxX) {
            self.maxSliderButton.X = panMaxX;
        }
        
        if (pan.state == UIGestureRecognizerStateChanged) {
            if (maxValue>_defalutMaxValue) {
                maxValue = _defalutMaxValue;
            }
            [self valueChanged:minValue maxX:maxValue];
        }else if (pan.state == UIGestureRecognizerStateEnded) {
            if (self.minSliderButton.X == self.maxSliderButton.X) {
                [self.sliderView sendSubviewToBack:self.maxSliderButton];
            }
        }
    }
    
    
}

/**maxSlider拖动事件*/
- (void)panMaxSliderButton:(UIPanGestureRecognizer *)pan {
    CGPoint panPoint = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
//禁止右滑
    
    NSInteger toX = self.maxSliderButton.X + panPoint.x;
    
    //        最小值
    CGFloat minX = self.minSliderButton.X-kMARGIN+12;
    NSInteger minValue = _defalutMinValue + minX/_scale;
    
    //        值区间
    CGFloat width = (slideScale*minValue -minValue)*self.scale;
    CGFloat rightmaxX = self.minSliderButton.X +width;
    
    if (toX > rightmaxX) {
        return;
    }
    
//    控制右侧滑块位置
    CGFloat panMaxX = CGRectGetMaxX(_backgroundIndicatorLabel.frame);
    
    if (toX >= self.minSliderButton.X && toX < panMaxX) {
        self.maxSliderButton.X = toX;
    }
    
    //        对应数值
    //        最大值
    CGFloat maxX = self.maxSliderButton.X-kMARGIN+12;
    NSInteger maxValue = maxX/_scale+_defalutMinValue;
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self valueChanged:minValue maxX:maxValue];
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.maxSliderButton.X == self.minSliderButton.X) {
            [self.sliderView sendSubviewToBack:self.minSliderButton];
        }
    }
}

- (void)valueChanged :(NSUInteger )minValue maxX:(NSUInteger)maxValue{
    
    [self configureIndicatorLableXW];
    
    
    if ([self.delegate respondsToSelector:@selector(customSliderValueChanged:minValue:maxValue:)]) {
        [self.delegate customSliderValueChanged:self minValue:[NSString stringWithFormat:@"%li",(long)minValue] maxValue:[NSString stringWithFormat:@"%li",(long)maxValue]];
    }
}

/**设置指示条的范围*/
- (void)configureIndicatorLableXW
{
    CGFloat indicatorMinX = self.minSliderButton.X+12;
    self.indicatorLabel.X = indicatorMinX;
    self.indicatorLabel.width = CGRectGetMaxX(self.maxSliderButton.frame)-indicatorMinX-12;
    _layoutOnceDone = YES;
}

#pragma mark - layz laoding
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"50",@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"2000"];
    }
    return _titleArray;
}

- (NSMutableArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

@end
