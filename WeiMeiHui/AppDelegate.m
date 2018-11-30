  //
//  AppDelegate.m
//  WeiMeiHui
//
//  Created by Mac on 17/4/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "AppDelegate.h"

#import "TZImagePickerController.h"
#import <CoreTelephony/CTCellularData.h>
//推送
#define XGAPPID 2200294463
#define XGAPPKEY  @"I97A94T9UNFE"

#import "LLTabBar.h"
#import "ChatViewController.h"



#import "UMMobClick/MobClick.h"
#import "FFToast.h"

//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "RecentOrderListsViewController.h"
#import "AuthorsAllOrderListViewController.h"
#import "SystemNotifyViewController.h"


#import "MMCheackNetWork.h"
#import "MainViewController.h"
#import "AuthorViewController.h"
#import "CustomizationPubViewController.h"
#import "ActivityViewController.h"
#import "MineViewController.h"

#import "LoginViewController.h"

#import "WeiAuthorTabController.h"
#import "WeiAuthorTabController.h"
#import "CYLTabBarController.h"
#import "CYLTabBarControllerConfig.h"

#import "JPUSHService.h"
#import "OrderWaitUseViewController.h"


#import "SELUpdateAlert.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#import <UserNotifications/UserNotifications.h>
@interface AppDelegate() <UNUserNotificationCenterDelegate>
@end
#endif


@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,OpenInstallDelegate>

@property(nonatomic,strong)MMCheackNetWork *cheacknet;
@end
 
@implementation AppDelegate

static NSInteger seq = 0;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    [self registerAPNS];
    
//    点击推送打开APP
    
//    检查网络权限
    
    //1.获取网络权限 根绝权限进行人机交互
    if (__IPHONE_10_0) {
        [self networkStatus:application didFinishLaunchingWithOptions:launchOptions];
    }else {
        //2.2已经开启网络权限 监听网络状态
        [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
    }
    
//    self.cheacknet = [MMCheackNetWork new];
//    [self.cheacknet performSelector:@selector(addObserverWithCheckNet) withObject:nil afterDelay:1];
    
    if ([PublicMethods isLogIn] ) {
        
        NSUInteger grade = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"level"] integerValue];
        
        if (grade != 3) {
            
            CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
            CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
            [self.window setRootViewController:tabBarController];
            
        }else{
            
            WeiAuthorTabController *authorVC = [[WeiAuthorTabController alloc]init];
            
            self.window.rootViewController = authorVC;
            
        }
        
        
    }else{
        
        WeiAuthorTabController *authorVC = [[WeiAuthorTabController alloc]init];
        
        self.window.rootViewController = authorVC;
        
}
    

    
    
    //分享
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        @(SSDKPlatformTypeTencentWeibo),
                                        @(SSDKPlatformSubTypeQZone)] onImport:^(SSDKPlatformType platformType) {
                                            
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeWechat:
                                                    [ShareSDKConnector connectWeChat:[WXApi class]];
                                                    break;
                                                case SSDKPlatformTypeQQ:
                                                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                    break;
                                                case SSDKPlatformTypeSinaWeibo:
                                                    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                    break;
                                                    
                                                default:
                                                    break;
                                            }

                                            
                                        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                            
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeSinaWeibo:
                                                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                                    [appInfo SSDKSetupSinaWeiboByAppKey:@"1194676512"
                                                                              appSecret:@"2ad73f29be803d153d97505c692bfab7"
                                                                            redirectUri:@"http://try.wmh1181.com"
                                                                               authType:SSDKAuthTypeBoth];
                                                    break;
                                                case SSDKPlatformTypeWechat:
                                                    [appInfo SSDKSetupWeChatByAppId:@"wxbb6becd4bf51596e"
                                                                          appSecret:@"737f45da13ab59c012fc818f6623ba28"];
                                                    break;
                                                case SSDKPlatformTypeQQ:
                                                    [appInfo SSDKSetupQQByAppId:@"1105399324"
                                                                         appKey:@"KybVGFmmGGUZCPCZ"
                                                                       authType:SSDKAuthTypeBoth];
                                                    break;
                                                default:
                                                    break;
                                            }
                                            
                                        }];

    //高德地图
    [AMapServices sharedServices].apiKey =@"fe16b2829b910fde376936d332e8931c";
    
    //微信支付
    [WXApi registerApp:@"wxbb6becd4bf51596e"];
    
    if (launchOptions) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:UNREAD];
        //                          发通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:YYChangeRedPoint object:self userInfo:nil];
        
    }
    
    
    [OpenInstallSDK initWithDelegate:self];
    
    
    UMConfigInstance.appKey = UMAPPKEY;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.ePolicy = SEND_INTERVAL;
    [MobClick setLogEnabled:YES];
    NSString *version = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
    
//  初始化 SDK，传入 AppKey
    
    [[RCIM sharedRCIM] initWithAppKey:@"4z3hlwrv4a9xt"];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];

    if ([PublicMethods isLogIn]) {

        NSString *rong_token = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"rong_token"];
        //            连接融云服务器
        [[RCIM sharedRCIM] connectWithToken:rong_token     success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);

        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];

    }
    
    
    // 极光注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:NO
            advertisingIdentifier:nil];
   
    
    NSString *account = @"";
    
    if ([PublicMethods isLogIn]) {
        account = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"phone"];
    }
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        if(resCode == 0){
            
            
            [JPUSHService setAlias:account completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
//                NSLog(@"极光别名注册的回调方法rescode: %ld, \ntags: %ld, \nalias: %@\n", (long)iResCode, (long)seq ,iAlias);
                if (iResCode == 0) {
                    // 注册成功
//                    NSLog(@"极光别名注册的回调成功");
                }
                
            } seq:seq];
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
        
    }];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //    版本更新
    
    [self checkVersion];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:WEICoupon];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    openinstall
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLauchApp"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLauchApp"];
        
        [self getInstallParamsImmediately];
        
    }
    
    return YES;
}

#pragma mark- openinstall
-(void)getInstallParamsImmediately{
    
    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
        
        if (appData.data) {//(动态安装参数)
            //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
        }
        if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
            //e.g.可自己统计渠道相关数据等
        }
        
        
        //弹出提示框(便于调试，调试完成后删除此代码)
        NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
        NSString *getData;
        if (appData.data) {
            //中文转换，方便看数据
            getData = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:appData.data options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:appData.data[@"invite_vid"] forKey:OpenInstallStr];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n"
//                               @"1、新应用是否上传安装包(是否集成完毕)  "
//                               @"2、是否正确配置appKey  "
//                               @"3、是否通过含有动态参数的分享链接(或二维码)安装的app\n\n动态参数：\n%@\n渠道编号：%@",
//                               getData,appData.channelCode];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"安装参数(示例1)" message:parameter preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }]];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
        
    }];
    
}

// 通过OpenInstall获取已经安装App被唤醒时的参数（如果是通过渠道页面唤醒App时，会返回渠道编号）
-(void)getWakeUpParams:(OpeninstallData *)appData{
    
    if (appData.data) {//(动态唤醒参数)
        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
    }
    if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
        //e.g.可自己统计渠道相关数据等
    }
    
    //弹出提示框(便于调试，调试完成后删除此代码)
    NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
    NSString *getData;
    if (appData.data) {
        //如果有中文，转换一下方便展示
        getData = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:appData.data options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
//    NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n"
//                           @"是否通过含有动态参数的分享链接(或二维码)安装的app\n\n动态参数：\n%@\n渠道编号：%@",
//                           getData,appData.channelCode];
//    UIAlertController *testAlert = [UIAlertController alertControllerWithTitle:@"唤醒参数" message:parameter preferredStyle:UIAlertControllerStyleAlert];
//    [testAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    }]];
//    
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:testAlert animated:true completion:nil];
    
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    
    //判断是否通过OpenInstall Universal Links 唤起App
    if ([OpenInstallSDK continueUserActivity:userActivity]) {
        
        return YES ;
    }
    
    //其他代码
    return YES;
    
}


/*
 CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题
 获取网络权限状态
 */
- (void)networkStatus:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //2.根据权限执行相应的交互
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    
    /*
     此函数会在网络权限改变时再次调用
     */
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        switch (state) {
            case kCTCellularDataRestricted:
                
                NSLog(@"Restricted");
                //2.1权限关闭的情况下 再次请求网络数据会弹出设置网络提示
                if (iOS8Later) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在设置中为微美惠开启网络权限" message:@"" delegate:self cancelButtonTitle:[NSBundle tz_localizedStringForKey:@"Cancel"] otherButtonTitles:[NSBundle tz_localizedStringForKey:@"Setting"], nil];
                    alert.delegate = self;
                    [alert show];
                    
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在设置中为微美惠开启网络权限" message:@"" delegate:self cancelButtonTitle:[NSBundle tz_localizedStringForKey:@"OK"] otherButtonTitles:nil];
                    alert.delegate = self;
                    [alert show];
                    
                }
                
                break;
            case kCTCellularDataNotRestricted:
                
                NSLog(@"NotRestricted");
                //2.2已经开启网络权限 监听网络状态
                [self addReachabilityManager:application didFinishLaunchingWithOptions:launchOptions];
                //                [self getInfo_application:application didFinishLaunchingWithOptions:launchOptions];
                break;
            case kCTCellularDataRestrictedStateUnknown:
                
                NSLog(@"Unknown");
                //2.3未知情况 （还没有遇到推测是有网络但是连接不正常的情况下）
                
                break;
                
            default:
                break;
        }
    };
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) { // 去设置界面，开启权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

/**
 实时检查当前网络状态
 */
- (void)addReachabilityManager:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    //这个可以放在需要侦听的页面
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                

                break;
            }
            default:
                break;
        }
    }];
    
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
}




// 极光别名注册的回调方法
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"极光别名注册的回调方法rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    if (iResCode == 0) {
        // 注册成功
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if (![PublicMethods isHaveMessage]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    

    if (application.applicationIconBadgeNumber>0) {  //badge number 不为0，说明程序有那个圈圈图标
        NSLog(@"我可能收到了推送");
        //这里进行有关处理
        [application setApplicationIconBadgeNumber:0];   //将图标清零。
        
        
        
    }
    
    //            连接融云
    if ([PublicMethods isLogIn]) {
        
        NSString *rong_token = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"rong_token"];
        //            连接融云服务器
        [[RCIM sharedRCIM] connectWithToken:rong_token     success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];
        
    }
    

}

#pragma mark- 检查版本
- (void)checkVersion{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *iosCurrentVersion = [NSString stringWithFormat:@"%@.%@",appCurVersion,app_build];
    
//    NSLog(@"当前应用软件版本:%@",appCurVersion);
    NSString *url = [PublicMethods dataTojsonString:@{@"type":@"1",@"ios_version":appCurVersion}];
    
    [YYNet POST:CheckVersion paramters:@{@"json":url} success:^(id responseObject) {
        
        NSDictionary *dic = [solveJsonData changeType:responseObject];
        
        if ([dic[@"data"] isKindOfClass:[NSDictionary class]]) {
        
            NSString *iosVersion = [dic[@"data"] objectForKey:@"ios_version"] ;
            
            if (![iosVersion isEqualToString: iosCurrentVersion]) {
                [SELUpdateAlert showUpdateAlertWithVersion:[dic[@"data"] objectForKey:@"ios_version"] Descriptions:@[[dic[@"data"] objectForKey:@"ios_update_content"]]];
            }
            
        }
        
        
        
    
        
    } faild:^(id responseObject) {
        
    }];
    
    
}



- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //支付宝支付
    NSString *absolute = url.absoluteString;
    // 添加次判断是为了以后多种支付并存时的准备（区分是谁的回调）
    if ([absolute hasPrefix:@"alisdkdemo"]) {// 与URL Schemes 的内容相同
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            // 手机装有支付宝软件
            // 支付后调用的地方
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    //微信的支付回调
    if ([url.host isEqualToString:@"weixinpay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    //发送通知
    
    //支付宝支付
    NSString *absolute = url.absoluteString;
    // 添加次判断是为了以后多种支付并存时的准备（区分是谁的回调）
    if ([absolute hasPrefix:@"alisdkdemo"]) {// 与URL Schemes 的内容相同
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            // 手机装有支付宝软件
            // 支付后调用的地方
            NSLog(@"result = %@",resultDic);
              [[NSNotificationCenter defaultCenter] postNotificationName:@"payNotifyALI" object:self userInfo:resultDic];
            
        }];
    }
    
    //微信的支付回调
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
    
}

//微信处理结果回调
-(void)onResp:(BaseResp *)resp{
    
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
            {
                                NSLog(@"支付结果: 成功!");
                NSDictionary *resultDic = @{@"info":@"1"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payNotifyWEI" object:self userInfo:resultDic];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                NSDictionary *resultDic = @{@"info":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payNotifyWEI" object:self userInfo:resultDic];
                
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                NSDictionary *resultDic = @{@"info":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payNotifyWEI" object:self userInfo:resultDic];
                
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSDictionary *resultDic = @{@"info":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payNotifyWEI" object:self userInfo:resultDic];
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSDictionary *resultDic = @{@"info":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payNotifyWEI" object:self userInfo:resultDic];
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSDictionary *resultDic = @{@"info":@"0"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payNotifyWEI" object:self userInfo:resultDic];
                
            }
                break;
            default:
                break;
        }
        //------------------------
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark- 注册设备信息
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString *tokenr = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">"
                        withString:@""] stringByReplacingOccurrencesOfString:@" "
                       withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:tokenr];
    

}


/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
#pragma mark- app 运行时收到通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"[融云] userinfo %@", userInfo);
    
    NSLog(@"[XGDemo] receive Notification");
    
   
    if ([userInfo[@"type"] integerValue] == 1) {
        
    }
    
    if ([userInfo[@"type"] integerValue] == 2) {
        
    }
    
    if ([userInfo[@"type"] integerValue] == 3) {
        
    }
    
    //完成之后的处理
    //userinfo里是运行时推送的弹窗信息
    
//    int i =0;
//    i = i+ [userInfo[@"badge"]intValue];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
//    NSLog(@"[xg push completion]userInfo is %@",userInfo);
    
    
}


/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"[XGDemo] receive slient Notification");
    NSLog(@"[XGDemo] userinfo %@", userInfo);
   
   [JPUSHService handleRemoteNotification:userInfo];
    
    if ([userInfo[@"type"] integerValue] == 1) {
        
    }
    
    if ([userInfo[@"type"] integerValue] == 2) {
        
    }
    
    if ([userInfo[@"type"] integerValue] == 3) {
        
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}


// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调,点击通知跳转接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
//    NSDictionary *infor = response.notification.request.content.userInfo;
//    //跳转私信界面
//
//        ChatViewController *mesVC = [[ChatViewController alloc]init];
//        mesVC.targetId = [infor[@"rc"] objectForKey:@"tId"];
//        mesVC.conversationType = ConversationType_PRIVATE;
//        [self.window.rootViewController presentViewController:mesVC animated:YES completion:nil];
    
//    信鸽
    //    response.notification.request.content.badge
    NSLog(@"[XGDemo] click notification");
//    点击推送消息，应用没有被杀死
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [JPUSHService handleRemoteNotification:userInfo];
    
    if ([userInfo[@"type"] integerValue] == 1) {
        
        AuthorsAllOrderListViewController *mesVC = [[AuthorsAllOrderListViewController alloc]init];
        mesVC.type = 1;
        [self.window.rootViewController presentViewController:mesVC animated:YES completion:nil];
        
    }
    
    if ([userInfo[@"type"] integerValue] == 2) {
        
        RecentOrderListsViewController *mesVC = [[RecentOrderListsViewController alloc]init];
        [self.window.rootViewController presentViewController:mesVC animated:YES completion:nil];
        
    }
    
    if ([userInfo[@"type"] integerValue] == 3) {
        SystemNotifyViewController *mesVC = [[SystemNotifyViewController alloc]init];
        [self.window.rootViewController presentViewController:mesVC animated:YES completion:nil];
    }
    
    completionHandler();

    
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
     [JPUSHService handleRemoteNotification:userInfo];
    
    if ([userInfo[@"type"] integerValue] == 1) {
        
    }
    
    if ([userInfo[@"type"] integerValue] == 2) {
        
    }
    
    if ([userInfo[@"type"] integerValue] == 3) {
        
    }
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    
}



#endif

- (void)registerAPNS {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        // iOS 8-9
        [self registerPush8to9];
    }
#else
    if (sysVer < 8) {
        // before iOS 8
        //        [self registerPushBefore8];
    } else {
        // iOS 8-9
        [self registerPush8to9];
    }
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush8to9{
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    
    
    //创建一个NSURL：请求路径
    NSString *url = [PublicMethods dataTojsonString:@{@"uuid":userId}];

    
    [YYNet POST:UserRCloud paramters:@{@"json":url} success:^(id responseObject) {

        NSDictionary *dic = [solveJsonData changeType:responseObject];

        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.name = [dic[@"data"] objectForKey:@"nickname"];
        user.portraitUri = [dic[@"data"] objectForKey:@"image"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefrshChatList" object:nil];
        
        return completion(user);

    } faild:^(id responseObject) {

    }];
    
    
}


#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        if ([userInfo[@"type"] integerValue] == 1) {
            
            AuthorsAllOrderListViewController *mesVC = [[AuthorsAllOrderListViewController alloc]init];
            mesVC.type = 1;
           [((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:mesVC animated:YES];
            
        }
        
        if ([userInfo[@"type"] integerValue] == 2) {
            
            RecentOrderListsViewController *mesVC = [[RecentOrderListsViewController alloc]init];
            [((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:mesVC animated:YES];
        }
        
        if ([userInfo[@"type"] integerValue] == 3) {
            
            SystemNotifyViewController *mesVC = [[SystemNotifyViewController alloc]init];
            [((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:mesVC animated:YES];
            
        }
        
        if ([userInfo[@"type"] integerValue] == 4) {
            
            OrderWaitUseViewController *grVC = [[OrderWaitUseViewController alloc]init];
            grVC.status = @"待使用";
            grVC.titleStr = @"微美惠拼团购";
            grVC.type = @"2";
            grVC.ID = userInfo[@"order_num"];
//             [self.window.rootViewController presentViewController:grVC animated:YES completion:nil];
              [((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:grVC animated:YES];
        }
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
      
//       手艺人 订制订单
        if ([userInfo[@"type"] integerValue] == 1) {
            
            AuthorsAllOrderListViewController *mesVC = [[AuthorsAllOrderListViewController alloc]init];
            mesVC.type = 1;
            [((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:mesVC animated:YES];
            
        }
        
//          普通用户订制订单
        if ([userInfo[@"type"] integerValue] == 2) {
            
            RecentOrderListsViewController *mesVC = [[RecentOrderListsViewController alloc]init];
            [((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:mesVC animated:YES];
            
        }
        
//        系统消息
        if ([userInfo[@"type"] integerValue] == 3) {
            SystemNotifyViewController *mesVC = [[SystemNotifyViewController alloc]init];
            [((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:mesVC animated:YES];
        }
        
//        拼团成功
        if ([userInfo[@"type"] integerValue] == 4) {
            
            OrderWaitUseViewController *grVC = [[OrderWaitUseViewController alloc]init];
            grVC.status = @"待使用";
            grVC.titleStr = @"微美惠拼团购";
            grVC.type = @"2";
            grVC.ID = userInfo[@"order_num"];
            [((UITabBarController *)self.window.rootViewController).selectedViewController pushViewController:grVC animated:YES];
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}


#pragma mark - 融云前台接收到消息
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
//    加红点
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:UNREAD];
    
//手艺人
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"level"] integerValue] == 2) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
             [self.cyl_tabBarController.tabBar showBadgeOnItmIndex:1 tabbarNum:5];
            
        });

        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
             [((UITabBarController *)self.window.rootViewController).tabBar  showBadgeOnItmIndex:4 tabbarNum:5];
            
        });
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"redPointNotify" object:self userInfo:@{}];
        
    }
    
}

//禁用第三方输入键盘

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier

{
    
    return NO;
    
}

@end
