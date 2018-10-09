//
//  NextFreeNewViewController.m
//  WeiMeiHui
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "NextFreeNewViewController.h"
#import "PayStyleViewController.h"
#import "AuthorDetailViewController.h"
#import "AuthorGoodsListsViewController.h"
#import "AwardRecordsViewController.h"
#import "AddAdwardTimeViewController.h"
#import "InviteFriendsListViewController.h"
#import "MyCouponsViewController.h"
#import "AuthorWorkListsViewController.h"

#import "ShareService.h"
#import <WebKit/WebKit.h>

@interface NextFreeNewViewController ()<UIWebViewDelegate,JSFreePayInteral>
{
    YYHud *hud;
    WKWebView *wkWeb;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic) JSContext *context;
@property (copy, nonatomic) NSString *mes;
@property (weak, nonatomic) IBOutlet UIWebView *webView;



@end

@implementation NextFreeNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;
    
    _webView.userInteractionEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView.scrollView.bounces = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    hud = [[YYHud alloc]init];
    [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    [self configNavView];
}

- (void)configNavView {
    
    _bgView.frame = CGRectMake(0, 0, kWidth, SafeAreaHeight);
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(buttonWidth);
//        make.height.mas_equalTo(buttonWidth);
        make.left.mas_equalTo(self.bgView.mas_left).offset(Space);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-5);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth-Space*2);
        make.height.mas_equalTo(LabelHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(Space);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
//    _titleLabel.text = self.titleStr;
    _webView.frame = CGRectMake(0, SafeAreaHeight, kWidth, kHeight-SafeAreaHeight);
    
    
   
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!_isMain) {
        self.tabBarController.tabBar.hidden= YES;
    }else{
         self.tabBarController.tabBar.hidden= NO;
        self.backBtn.hidden = YES;
    }
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    
    if ([PublicMethods isLogIn]) {
        
        NSString* uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
        _url = [NSString stringWithFormat:@"%@/uuid/%@/lat/%@/lng/%@",_url,uuid,lat,lng];
    }
    
    //    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:_url]];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL urlWithNoBlankDataString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    [_webView loadRequest: req];
    
}

//界面加载完毕
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"OC"] = self;
    
     self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
     [hud dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [hud dismiss];
    
}
#pragma - mark - 去支付
- (void)callMobilePay:(NSString *)callback_we_url call:(NSString *)callback_ali_url order:(NSString *)order_num price:(NSString *)pirce{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PayStyleViewController *payVc= [[PayStyleViewController alloc]init];
        payVc.ordernumber = order_num;
        payVc.price = pirce;
        payVc.notifyUrlAli = callback_ali_url;
        payVc.notifyUrlWeixin = callback_we_url;
        [self.navigationController pushViewController:payVc animated:YES];
        
    });
    
}

- (void)shopCardPay:(NSString *)callback_we_url call:(NSString *)callback_ali_url order:(NSString *)order_num price:(NSString *)pirce{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PayStyleViewController *payVc= [[PayStyleViewController alloc]init];
        payVc.ordernumber = order_num;
        payVc.price = pirce;
        payVc.notifyUrlAli = callback_ali_url;
        payVc.notifyUrlWeixin = callback_we_url;
        payVc.isCard = YES;
        [self.navigationController pushViewController:payVc animated:YES];
        
    });
    
}

#pragma - mark - 去登录
- (void)callMobileLogin{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        LoginViewController *logVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:logVC animated:YES];
    
     });
}

/**
 1.跳转手艺人详情
 */

- (void)callMobileAuthor:(NSString *)author_uuid {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AuthorDetailViewController *weiVC  = [[AuthorDetailViewController alloc]init];
        weiVC.ID = author_uuid;
        [self.navigationController pushViewController:weiVC animated:YES];
        
    });
    
    
}


/**
 1.跳转手艺人列表
 */
- (void)callMobileAuthorList:(NSString *)type Activity:(NSString *)activity_id Title:(NSString *)title{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AuthorGoodsListsViewController *payVc= [[AuthorGoodsListsViewController alloc]init];
        payVc.activityID = activity_id;
        payVc.type = type;
        payVc.titleStr = title;
        [self.navigationController pushViewController:payVc animated:YES];
        
    });
    
}




/**
 获取更多抽奖机会
 */
- (void)callMobileAddLotteryList{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AddAdwardTimeViewController *weiVC  = [[AddAdwardTimeViewController alloc]init];
        [self.navigationController pushViewController:weiVC animated:YES];
        
    });
    
   
    
}

/**
 获取抽奖记录
 */
- (void)callMobileLotteryList{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AwardRecordsViewController *weiVC  = [[AwardRecordsViewController alloc]init];
        [self.navigationController pushViewController:weiVC animated:YES];
        
    });
    
    
    
}

/**
 邀请好友列表
 */
- (void)callMobileInvite{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        InviteFriendsListViewController *weiVC  = [[InviteFriendsListViewController alloc]init];
        [self.navigationController pushViewController:weiVC animated:YES];
        
    });
    
    
    
}


/**
 分享到微信
 */
- (void)callMobileWechat:(NSString *)shareURL content:(NSString *)content pic:(NSString *)pic title:(NSString *)title{
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString* uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *finalUrl = [NSString stringWithFormat:@"%@/uuid/%@/lat/%@/lng/%@",shareURL,uuid,lat,lng];
    
//    [[ShareService shared] shareAddFriendsType:SSDKPlatformSubTypeWechatSession url:[NSURL urlWithNoBlankDataString:finalUrl] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:finalUrl];
    
//     [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[ShareService shared] shareAddFriendsType:SSDKPlatformSubTypeWechatSession url:[NSURL urlWithNoBlankDataString:finalUrl] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:finalUrl];
        
    });
    
//    [hud dismiss];
    
}

/**
 分享到QQ
 */
- (void)callMobileQQ:(NSString *)shareURL content:(NSString *)content pic:(NSString *)pic title:(NSString *)title{
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString* uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *finalUrl = [NSString stringWithFormat:@"%@/uuid/%@/lat/%@/lng/%@",shareURL,uuid,lat,lng];
    
//    [[ShareService shared] shareAddFriendsType:SSDKPlatformSubTypeQQFriend url:[NSURL urlWithNoBlankDataString:finalUrl] img:@"test" text:content andShareType:SSDKContentTypeAuto copyUrl:finalUrl];
    
//     [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[ShareService shared] shareAddFriendsType:SSDKPlatformSubTypeQQFriend url:[NSURL urlWithNoBlankDataString:finalUrl] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:finalUrl];
        
    });
    
//    [hud dismiss];
    
}

/**
 分享到微信朋友圈
 */
- (void)callMobileGroup:(NSString *)shareURL content:(NSString *)content pic:(NSString *)pic title:(NSString *)title{
    
    NSString *lat = [[NSUserDefaults standardUserDefaults] valueForKey:WEILat];
    NSString *lng = [[NSUserDefaults standardUserDefaults] valueForKey:WEIlngi];
    NSString* uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
    NSString *finalUrl = [NSString stringWithFormat:@"%@/uuid/%@/lat/%@/lng/%@",shareURL,uuid,lat,lng];
    
//    [[ShareService shared] shareAddFriendsType:SSDKPlatformSubTypeWechatTimeline url:[NSURL urlWithNoBlankDataString:finalUrl] img:@"test" text:content andShareType:SSDKContentTypeAuto copyUrl:finalUrl];
    
//     [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[ShareService shared] shareAddFriendsType:SSDKPlatformSubTypeWechatTimeline url:[NSURL urlWithNoBlankDataString:finalUrl] img:pic titleText:title text:content andShareType:SSDKContentTypeAuto copyUrl:finalUrl];
        
    });
    
//    [hud dismiss];
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    [hud dismiss];
    
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
//    [hud dismiss];
   
    
}

- (IBAction)popAction:(UIButton *)sender {
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
    } else {
        [self.navigationController  popViewControllerAnimated:YES];
    }
    
}

/**
 跳转我的卡券
 */
- (void)callMobileMyCouponList{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MyCouponsViewController *weiVC  = [[MyCouponsViewController alloc]init];
        [self.navigationController pushViewController:weiVC animated:YES];
        
    });
    
    
    
}

- (void)WebAuthorProduct:(NSString *)author_uuid{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AuthorWorkListsViewController *shopVC= [[AuthorWorkListsViewController alloc]init];
        shopVC.authorUuid = author_uuid;
        [self.navigationController pushViewController:shopVC animated:YES];
        
    });
    

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [hud dismiss];
    
}
@end
