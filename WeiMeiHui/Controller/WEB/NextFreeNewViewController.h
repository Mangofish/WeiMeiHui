//
//  NextFreeNewViewController.h
//  WeiMeiHui
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSFreePayInteral <JSExport>

/**
 1.跳转手艺人详情
 */
- (void)callMobileAuthor:(NSString *)author_uuid;

/**
 1.跳转手艺人列表
 */
- (void)callMobileAuthorList:(NSString *)type Activity:(NSString *)activity_id Title:(NSString*)title;

/**
 支付
 */
- (void)callMobilePay:(NSString *)callback_we_url call:(NSString *)callback_ali_url order:(NSString *)order_num price:(NSString *)pirce;

/**
 卡支付
 */
- (void)shopCardPay:(NSString *)callback_we_url call:(NSString *)callback_ali_url order:(NSString *)order_num price:(NSString *)pirce;


/**
 登录
 */
- (void)callMobileLogin;

/**
 获取更多抽奖机会
 */
- (void)callMobileAddLotteryList;

/**
 获取抽奖记录
 */
- (void)callMobileLotteryList;

/**
邀请好友列表
 */
- (void)callMobileInvite;

/**
 分享到微信
 */
- (void)callMobileWechat:(NSString *)shareURL content:(NSString *)content pic:(NSString *)pic title:(NSString *)title;

/**
 分享到QQ
 */
- (void)callMobileQQ:(NSString *)shareURL content:(NSString *)content pic:(NSString *)pic title:(NSString *)title;

/**
 分享到微信朋友圈
 */
- (void)callMobileGroup:(NSString *)shareURL content:(NSString *)content pic:(NSString *)pic title:(NSString *)title;

/**
 跳转我的卡券
 */
- (void)callMobileMyCouponList;

/**
 跳转作品列表
 */
- (void)WebAuthorProduct:(NSString *)author_uuid;


@end

@interface NextFreeNewViewController : UIViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isMain;

@end
