//
//  WeiAuthorTabController.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiAuthorTabController.h"

#import "MainViewController.h"
#import "RecentOrderListsViewController.h"
#import "MineViewController.h"
#import "ChatListViewController.h"
#import "InformationsViewController.h"

#import "CustomizationPubViewController.h"
#import "LoginViewController.h"

#import "BHBPopView.h"
@implementation WeiAuthorTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainViewController *homeViewController = [[MainViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:homeViewController];
    
     InformationsViewController*sameCityViewController = [[InformationsViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:sameCityViewController];
    
    RecentOrderListsViewController *author = [[RecentOrderListsViewController alloc]init];
    author.isMain = 1;
    UINavigationController *nav3= [[UINavigationController alloc]initWithRootViewController:author];
    
    MineViewController *messageViewController = [[MineViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:messageViewController];
    
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    LLTabBar *tabBar = [[LLTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.tabBarItemAttributes = @[@{kLLTabBarItemAttributeTitle : @"", kLLTabBarItemAttributeNormalImageName : @"首页1", kLLTabBarItemAttributeSelectedImageName : @"首页2", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
                                    @{kLLTabBarItemAttributeTitle : @"", kLLTabBarItemAttributeNormalImageName : @"资讯", kLLTabBarItemAttributeSelectedImageName : @"资讯2", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
                                    @{kLLTabBarItemAttributeTitle : @"", kLLTabBarItemAttributeNormalImageName : @"发布定制", kLLTabBarItemAttributeSelectedImageName : @"发布定制", kLLTabBarItemAttributeType : @(LLTabBarItemRise)},
                                    @{kLLTabBarItemAttributeTitle : @"", kLLTabBarItemAttributeNormalImageName : @"订单", kLLTabBarItemAttributeSelectedImageName : @"订单2", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
                                    @{kLLTabBarItemAttributeTitle : @"", kLLTabBarItemAttributeNormalImageName : @"我的1", kLLTabBarItemAttributeSelectedImageName : @"我的2", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)}];
    
    tabBar.delegate = self;
    tabBar.tag = 10086;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.viewControllers = @[nav1, nav2, nav3, nav4];
    
//    CGRect frame = CGRectMake(4*kWidth/5-33, 5, 28, 12);
//    UIImageView *img = [[UIImageView alloc]initWithFrame:frame];
//    img.image = [UIImage imageNamed:@"HOT"];
//    [tabBar addSubview:img];
    [self.tabBar addSubview:tabBar];
    
   [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    
}

#pragma mark - LLTabBarDelegate
//跳转发布界面
- (void)tabBarDidSelectedRiseButton {
    
    
    UIViewController *viewController = self.selectedViewController;
    
    if ([PublicMethods isLogIn]) {
    
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:WEIPUBLISH] integerValue] == 0) {
            
            
            
            BHBItem * item0 = [[BHBItem alloc]initWithTitle:@"咨询顾问" Icon:@"咨询顾问"];
            BHBItem * item1 = [[BHBItem alloc]initWithTitle:@"定制服务" Icon:@"定制服务"];
           
            //添加popview,item2,item3,item4,item5
            [BHBPopView showToView:self.view.window withItems:@[item0,item1]andSelectBlock:^(BHBItem *item) {
                
                if ([item.title isEqualToString:@"定制服务"]) {
                    
                    UIViewController *viewController = self.selectedViewController;
                    CustomizationPubViewController *pubVC = [[CustomizationPubViewController alloc]init];
                    [viewController showViewController:pubVC sender:nil];
                    
                }else{
                    
                    UIWebView * callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:[NSString stringWithFormat:@"tel://043181615320"]]]];
                    [self.view addSubview:callWebview];
                    
                }
                
            }];
            
            
        }else{
            
            FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"由于您有未完成订单，暂时无法发布定制！" iconImage:[UIImage imageNamed:@"warning"]];
            toast.toastType = FFToastTypeWarning;
            toast.toastPosition = FFToastPositionCentreWithFillet;
            [toast show];
            
        }
        
        
    }else{
        LoginViewController *pubVC = [[LoginViewController alloc]init];
        [viewController showViewController:pubVC sender:nil];
    }
    
}

#pragma mark - 获取数据
- (void)getData{
    
    
    NSString *city_id = @"";
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID]) {
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEICITYID];
    }else{
        city_id = [[NSUserDefaults standardUserDefaults] valueForKey:WEILocationCITYID];
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString *uuid = @"";
    
    if ([PublicMethods isLogIn]) {
        uuid =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    }
    
    if (!city_id.length) {
        city_id = @"";
    }
    
    
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid,@"city_id":city_id,@"type":@(1),@"lat":lat,@"lng":lng}];
    
    [YYNet POST:INDEXList paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dict = [solveJsonData changeType:responseObject];
        NSDictionary *dic = dict[@"data"];
        
        NSUInteger type = [[dic[@"order_data"] objectForKey:@"type"] integerValue];
        
        [[NSUserDefaults standardUserDefaults] setValue:@(type) forKey:WEIPUBLISH];
        
        
       
        
    } faild:^(id responseObject) {
        
        
        
    }];
    
}


#pragma mark - 获取原始的图片
-(UIImage *)getOriginalImageWithImageName:(NSString *)imgName{
    UIImage *image = [UIImage imageNamed:imgName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
    
}

#pragma mark - 红点
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
     [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:UNREAD];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tabBar  showBadgeOnItmIndex:4 tabbarNum:5];
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"redPointNotify" object:self userInfo:@{}];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

//    [self getData];
}



@end
