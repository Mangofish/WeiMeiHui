//
//  APAuthInfo.h
//  AliSDKDemo
//
//  Created by 方彬 on 14-7-18.
//  Copyright (c) 2014年 Alipay.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APayAuthInfo : NSObject

@property(nonatomic, copy)NSString *appID;
@property(nonatomic, copy)NSString *pid;
@property(nonatomic, copy)NSString *redirectUri;


- (id)initWithAppID:(NSString *)appIDStr
                pid:(NSString *)pidStr
        redirectUri:(NSString *)uriStr;

- (NSString *)description;
- (NSString *)wapDescription;
@end
