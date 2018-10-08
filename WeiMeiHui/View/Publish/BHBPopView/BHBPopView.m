//
//  BHBPopView.m
//  BHBPopViewDemo
//
//  Created by 毕洪博 on 15/8/14.
//  Copyright (c) 2015年 毕洪博. All rights reserved.
//

#import "BHBPopView.h"
#import "UIImage+BHBEffects.h"
#import "UIView+BHBAnimation.h"
#import "UIImageView+BHBSetImage.h"

#import "BHBBottomBar.h"
#import "BHBCustomBtn.h"
#import "UIButton+BHBSetImage.h"
#import "BHBCenterView.h"

#import "CircleRippleView.h"
#import "UIImage+WebP.h"

@interface BHBPopView ()<BHBCenterViewDelegate,BHBCenterViewDataSource>

@property (nonatomic,weak) UIImageView * background;
@property (nonatomic,weak) UIImageView * logo;
@property (nonatomic,weak) BHBBottomBar * bottomBar;
@property (nonatomic,weak) BHBCenterView * centerView;

@property (nonatomic,strong) NSArray * items;
@property (nonatomic,copy) DidSelectItemBlock selectBlock;
@property (nonatomic,strong) CircleRippleView * circleRippleView;

@end

@implementation BHBPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:iv];
        self.background = iv;
        
        NSString *pic = [[NSUserDefaults standardUserDefaults] valueForKey:PlusAppPic];
        
        UIImageView * logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth)];
//        logo.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL urlWithNoBlankDataString:pic]]];
        [logo sd_setImageWithURL:[NSURL urlWithNoBlankDataString:pic] placeholderImage:[UIImage imageNamed:@"test2"]];
        logo.contentMode = UIViewContentModeScaleAspectFit;
//        logo.frame = self.center;
        [self addSubview:logo];
        self.logo = logo;
        
        self.circleRippleView = [[CircleRippleView alloc] initWithFrame:CGRectMake(0,0, 150, 150)];
        self.circleRippleView.center = self.center;
        self.circleRippleView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.circleRippleView];
        [self.circleRippleView startAnimation];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 115, 37)];
        btn.center = self.center;
        [self addSubview:btn];
        btn.backgroundColor =  [UIColor colorWithRed:255/255.0 green:36/255.0 blue:91/255.0 alpha:1];
        [btn setTitle:@"立即领取" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        btn.layer.cornerRadius = 18;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(getCoupon) forControlEvents:UIControlEventTouchUpInside];
        
        BHBBottomBar * bar = [[BHBBottomBar alloc]initWithFrame:CGRectMake(0, frame.size.height - BHBBOTTOMHEIGHT-20, frame.size.width, BHBBOTTOMHEIGHT+20)];
        __weak typeof(self) weakSelf = self;
        bar.backClick = ^{
            [weakSelf.centerView scrollBack];
        };
        bar.closeClick = ^{
//            [[BHBPlaySoundTool sharedPlaySoundTool] playWithSoundName:@"close"];
            [weakSelf hideItems];
            [weakSelf hide];
        };
        [self addSubview:bar];
        self.bottomBar = bar;
        BHBCenterView * centerView = [[BHBCenterView alloc]initWithFrame:CGRectMake(0, self.frame.size.height * 0.65, self.frame.size.width, self.frame.size.height * 0.25)];
        [self addSubview:centerView];
        centerView.delegate = self;
        centerView.dataSource = self;
        centerView.clipsToBounds = NO;
        self.centerView = centerView;
        
    }
    return self;
}

- (void)getCoupon{
    
    NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    
    if (!uuid) {
        uuid = @"";
    }
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid}];
    
    [YYNet POST:IndexGetCouponNew paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        //        领取成功
        FFToast *toast = [[FFToast alloc]initToastWithTitle:dict[@"info"] message:@"请在 我的-我的卡券 里查看" iconImage:[UIImage imageNamed:@"设置成功"]];
        toast.titleTextColor = [UIColor whiteColor];
        toast.messageTextColor = [UIColor whiteColor];
        toast.toastType = FFToastTypeSuccess;
        toast.toastBackgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
    
}

- (void)removeitemsComplete{
    self.superview.userInteractionEnabled = YES;
}


- (void)showItems{
    [self.centerView reloadData];
}

- (void)hideItems{
    [self.centerView dismis];
}


+ (BHB_INSTANCETYPE)showToView:(UIView *)view withItems:(NSArray *)array andSelectBlock:(DidSelectItemBlock)block{
//    [[BHBPlaySoundTool sharedPlaySoundTool] playWithSoundName:@"open"];
    [self viewNotEmpty:view];
    BHBPopView * popView = [[BHBPopView alloc]initWithFrame:view.bounds];
    popView.background.image = [self imageWithView:view];
    [view addSubview:popView];
    popView.selectBlock = block;
    [popView fadeInWithTime:0.25];
    popView.items = array;
    [popView showItems];
    return popView;
}

+ (BHB_INSTANCETYPE)showToView:(UIView *)view andImages:(NSArray *)imageArray andTitles:(NSArray *)titles andSelectBlock:(DidSelectItemBlock)block{
    NSUInteger count = imageArray.count;
    NSMutableArray * items = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        BHBItem * item = [[BHBItem alloc]initWithTitle:titles[i] Icon:imageArray[i]];
        [items addObject:item];
    }
    return [self showToView:view withItems:items andSelectBlock:block];
}

+ (UIImage *)imageWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), NO, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIColor *tintColor = [UIColor colorWithWhite:0.95 alpha:0.78];
    image = [image bhb_applyBlurWithRadius:15 tintColor:tintColor saturationDeltaFactor:1 maskImage:nil];
    UIGraphicsEndImageContext();
    
    return image;
}

+ (void)viewNotEmpty:(UIView *)view{
    if (view == nil) {
        view = (UIView *)[[UIApplication sharedApplication] delegate];
    }

}

+ (void)hideFromView:(UIView *)view{
    [self viewNotEmpty:view];
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView * subV = (UIView *)obj;
        [subV isKindOfClass:[self class]];
        [BHBPopView hideWithView:subV];
    }];
}

- (void)hide{
    [BHBPopView hideWithView:self];
}

+ (void)hideWithView:(UIView *)view{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [view fadeOutWithTime:0.35];
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [[BHBPlaySoundTool sharedPlaySoundTool] playWithSoundName:@"close"];
    [self.bottomBar btnResetPosition];
    [self.bottomBar fadeOutWithTime:.25];
    [self hideItems];
    [self hide];
}

#pragma mark centerview delegate and datasource
- (NSInteger)numberOfItemsWithCenterView:(BHBCenterView *)centerView
{
    return self.items.count;
}

-(BHBItem *)itemWithCenterView:(BHBCenterView *)centerView item:(NSInteger)item
{
    return self.items[item];
}

-(void)didSelectItemWithCenterView:(BHBCenterView *)centerView andItem:(BHBItem *)item
{
    if (self.selectBlock) {
        self.selectBlock(item);
    }
//    [[BHBPlaySoundTool sharedPlaySoundTool] playWithSoundName:@"open"];
    [self hide];
}

- (void)didSelectMoreWithCenterView:(BHBCenterView *)centerView andItem:(BHBGroup *)group
{
    if (self.selectBlock) {
        self.selectBlock(group);
    }
//    [[BHBPlaySoundTool sharedPlaySoundTool] playWithSoundName:@"open"];
    self.bottomBar.isMoreBar = YES;
}

- (void)dealloc{
//    NSLog(@"BHBPopView");
}

@end
