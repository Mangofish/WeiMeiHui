//
//  ShareService.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareService : NSObject

+ (instancetype)shared;


- (void)shareAddFriendsType:(SSDKPlatformType)type url:(NSURL *)url img:(NSString *)imgUrl titleText:(NSString *)titleText text:(NSString *)text andShareType:(SSDKContentType)shareType copyUrl:(NSString *)copyUrl;

- (void)shareType:(SSDKPlatformType)type url:(NSURL *)url img:(NSString *)imgUrl titleText:(NSString *)titleText text:(NSString *)text andShareType:(SSDKContentType)shareType copyUrl:(NSString *)copyUrl;

@end
