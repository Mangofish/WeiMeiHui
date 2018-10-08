//
//  PlayViewController.m
//  HealthCare
//
//  Created by apple on 2018/3/26.
//  Copyright © 2018年 com.wmhVender.WeiMeiHui. All rights reserved.
//

#import "PlayViewController.h"
#import "SYMediaPlayerView.h"
#import "UIView+SYExtend.h"

#import "AppDelegate.h"

#define TopMargin 20

#define MinPlayerHeight (kDWidth / 16 * 9)

@interface PlayViewController ()<SYMediaPlayerViewDelegate>

@property (nonatomic, strong)SYMediaPlayerView  *playerView;
@property (nonatomic, strong)UIView             *headerView;

@property(nonatomic, strong) UIButton *backBtn;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];

    
    _playerView=[[SYMediaPlayerView alloc]init];
    
//    NSString *mvUrl = @"http://39.106.161.137/Uploads/Download/2018-03-27/5ab99a1d1c0b2.mp4";
    
    
    
    [_playerView playerViewWithUrl:_urlStr WithTitle:@"" WithView:self.view  WithDelegate:self];
    
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(Space, 25, 30, 30)];
    [back setImage:[UIImage imageNamed:@"返回白"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(JZOnBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

- (void)JZOnBackBtn{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    if ([UIDevice currentDevice].orientation ==UIDeviceOrientationLandscapeLeft||[UIDevice currentDevice].orientation ==UIDeviceOrientationLandscapeRight){
        UIWindow*window= [UIApplication sharedApplication].keyWindow;
        _playerView.frame=CGRectMake(0, 0, size.width,size.height);
        _playerView.player.view.frame=CGRectMake(0, 0, size.width,size.height);
        _playerView.mediaControl.fullScreenBtn.selected=YES;
        _playerView.isFullScreen=YES;
        [window addSubview:_playerView];
    }else{
        _playerView.frame=CGRectMake(0, 0, size.width, size.width/16*9);
        _playerView.player.view.frame=CGRectMake(0, 0, size.width, size.width/16*9);
        _playerView.mediaControl.fullScreenBtn.selected=NO;
        _playerView.isFullScreen=NO;
        [_headerView addSubview:_playerView];
        
        
        
        
    }
}



- (void)playerViewClosed:(SYMediaPlayerView *)player{
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    
}

- (void)playerView:(SYMediaPlayerView *)player fullscreen:(BOOL)fullscreen{
    
    
    
    if (fullscreen==YES) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
    }else{
        
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}

- (void)playerViewFailePlay:(SYMediaPlayerView *)player {
    
}


- (BOOL)playerViewWillBeginPlay:(SYMediaPlayerView *)player {
    
    return YES;
}


//-(void) viewWillAppear:(BOOL) animated{
//    [self begainFullScreen];
//}
//
//-(void) viewWillDisappear:(BOOL)animated{
//    [self endFullScreen];
//}

//进入全屏
//-(void)begainFullScreen {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; appDelegate.allowRotation = YES;
//
//} // 退出全屏
//-(void)endFullScreen {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate]; appDelegate.allowRotation = NO;
//    //强制归正：
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val =UIInterfaceOrientationPortrait;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//
//    }
//
//}




@end
