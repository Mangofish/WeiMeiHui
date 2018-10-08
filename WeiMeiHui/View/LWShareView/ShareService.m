//
//  ShareService.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShareService.h"

@implementation ShareService

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static ShareService* service;
    dispatch_once(&onceToken, ^{
        service = [[ShareService alloc] init];
    });
    return service;
}

- (void)shareType:(SSDKPlatformType)type url:(NSURL *)url img:(NSString *)imgUrl titleText:(NSString *)titleText text:(NSString *)text andShareType:(SSDKContentType)shareType copyUrl:(NSString *)copyUrl {
    
    
    if (type == SSDKPlatformTypeCopy) {
        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已复制" iconImage:[UIImage imageNamed:@"success"]];
        toast.toastType = FFToastTypeSuccess;
        toast.toastPosition = FFToastPositionCentreWithFillet;
        [toast show];
        
        
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = copyUrl;
        
        return;
    }
    
    
    if (!text.length) {
        text = @"来自微美惠的分享";
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:imgUrl //传入要分享的图片
                                        url:url
                                      title:titleText
                                       type:shareType];
    
//    [shareParams ssdksetupshar];
    
    //进行分享
    [ShareSDK share:type //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
         
         if (state == SSDKResponseStateCancel) {
//             FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"分享取消" iconImage:[UIImage imageNamed:@"success"]];
//             toast.toastType = FFToastTypeSuccess;
//             toast.toastPosition = FFToastPositionCentreWithFillet;
//             [toast show];
         }
         
         if (state == SSDKResponseStateSuccess) {
            
             
             FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"已分享" iconImage:[UIImage imageNamed:@"success"]];
             toast.toastType = FFToastTypeSuccess;
             toast.toastPosition = FFToastPositionCentreWithFillet;
             [toast show];
             
             }
        
         
     }];
    
}




- (void)shareAddFriendsType:(SSDKPlatformType)type url:(NSURL *)url img:(NSString *)imgUrl titleText:(NSString *)titleText text:(NSString *)text andShareType:(SSDKContentType)shareType copyUrl:(NSString *)copyUrl{
    
    if (!text.length) {
        text = @"来自微美惠的分享";
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:imgUrl //传入要分享的图片
                                        url:url
                                      title:titleText
                                       type:shareType];
    
    //    [shareParams ssdksetupshar];
    
    //进行分享
    [ShareSDK share:type //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....}];
         
         if (state == SSDKResponseStateCancel) {
             //             FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:@"分享取消" iconImage:[UIImage imageNamed:@"success"]];
             //             toast.toastType = FFToastTypeSuccess;
             //             toast.toastPosition = FFToastPositionCentreWithFillet;
             //             [toast show];
         }
         
         if (state == SSDKResponseStateSuccess) {
             
             NSString *uuid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user"] objectForKey:@"uuid"];
             
             if (!uuid) {
                 uuid = @"";
             }
             
             NSString *url = [PublicMethods dataTojsonString:@{@"uuid":uuid}];
             
             [YYNet POST:InviteCallBack paramters:@{@"json":url} success:^(id responseObject) {
                 
                 NSDictionary *dict = [solveJsonData changeType:responseObject];
                 
                 FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"success"]];
                 toast.toastType = FFToastTypeSuccess;
                 toast.toastPosition = FFToastPositionCentreWithFillet;
                 [toast show];
                 
                 
             } faild:^(id responseObject) {
                 
                 NSDictionary *dict = [solveJsonData changeType:responseObject];
                 FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dict[@"info"] iconImage:[UIImage imageNamed:@"error"]];
                 toast.toastType = FFToastTypeError;
                 toast.toastPosition = FFToastPositionCentreWithFillet;
                 [toast show];
                 
             }];
             
         }
         
         
     }];
    
    
}

@end
