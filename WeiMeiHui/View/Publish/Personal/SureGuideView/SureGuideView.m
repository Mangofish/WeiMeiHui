//
//  SureGuideView.m
//  ProjectRefactoring
//
//  Created by 刘硕 on 2016/11/17.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureGuideView.h"
#import "UIImage+Adaptive.h"
#import "AppDelegate.h"
NSString *const SureShouldShowGuide = @"SureShouldShowGuide";
@interface SureGuideView ()
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) UIViewController *rootVC;

@property (nonatomic, strong) UIScrollView *scrollView;

@end
@implementation SureGuideView

+ (instancetype)sureGuideViewWithImageName:(NSString*)imageName
                                imageCount:(NSInteger)imageCount viewController:(UIViewController *)rootVC{
    return [[self alloc]initWithImageName:imageName imageCount:imageCount viewController:rootVC];
}

- (instancetype)initWithImageName:(NSString*)imageName
                       imageCount:(NSInteger)imageCount viewController:(UIViewController *)rootVC{
    if (self = [super init]) {
        _imageName = imageName;
        _imageCount = imageCount;
        _rootVC = rootVC;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_imageCount, 0);
    [self addSubview:self.scrollView];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    if (_imageCount) {
        for (NSInteger i = 0; i < _imageCount; i++) {
            NSString *realImageName = [NSString stringWithFormat:@"%@_%ld.png",_imageName, i+1];
            UIImage *image = [UIImage imageNamed:realImageName];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.frame = CGRectMake(0+i*(SCREEN_WIDTH), 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            imageView.userInteractionEnabled = YES;
            imageView.tag = 1000 + i;
            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageView:)];
//
//            UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageView:)];
//            [right setDirection:(UISwipeGestureRecognizerDirectionRight)];
//
//            UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageView:)];
//            [right setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//
//            [imageView addGestureRecognizer:tap];
//            [imageView addGestureRecognizer:left];
//            [imageView addGestureRecognizer:right];
            
            [self.scrollView addSubview:imageView];
        }
        
//        加按钮
        UIButton *removeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-Space - 50, SafeAreaHeight, 50, 24)];
        [removeBtn setImage:[UIImage imageNamed:@"跳过"] forState:UIControlStateNormal];
        [self addSubview:removeBtn];
        [removeBtn addTarget:self action:@selector(touchImageView) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*5+20, kHeight-20-40, kWidth-40, 40)];
        [startBtn setImage:[UIImage imageNamed:@"开始定制"] forState:UIControlStateNormal];
        [self.scrollView addSubview:startBtn];
        
        [startBtn addTarget:self action:@selector(touchImageView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [self show];
}

- (void)touchImageView{
//    UIImageView *tapImageView = (UIImageView*)tap.view;
//    //依次移除
//    [tapImageView removeFromSuperview];
//    if (tapImageView.tag - 1000 == 0) {
//        //最后一张
//        if (self.lastTapBlock) {
//            self.lastTapBlock();
//        }
        [self hide];
//    }
}

- (void)show {
//    [UIApplication sharedApplication].statusBarHidden = YES;
////    UIWindow *appDel = [UIApplication sharedApplication].keyWindow;
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    [_rootVC.view addSubview:self];
    [_rootVC.view bringSubviewToFront:self];
}

- (void)hide {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self removeFromSuperview];
}

+ (BOOL)shouldShowGuider {
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:SureShouldShowGuide];
    if ([number isEqual:@200]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:@200 forKey:SureShouldShowGuide];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
