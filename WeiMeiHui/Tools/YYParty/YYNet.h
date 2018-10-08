//
//  YYNet.h
//  ch12网络登录注册
//
//  Created by 于悦 on 16/7/29.
//  Copyright © 2016年 jereh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYNetModel.h"

typedef void (^Success)(id responseObject);
typedef void (^Faild)(id responseObject);

@interface YYNet : NSObject

//Get请求
+ (void) GET:(NSString *) path paramters:(NSDictionary *)dic success:(Success) success faild:(Faild)faild;

+ (void) GET:(NSString *) path paramter:(NSDictionary *)dic success:(Success) success faild:(Faild)faild;

//POST请求
+ (void) POST:(NSString *) path paramters:(NSDictionary *)dic success:(Success) success faild:(Faild)faild;




/**
 *  我是用来做上传的
 *
 *  @param path      <#path description#>
 *  @param dic       <#dic description#>
 *  @param fileModel <#fileModel description#>
 *  @param success   <#success description#>
 *  @param faild     <#faild description#>
 */



+ (void) upLoad:(NSString *)path paramter:(NSDictionary *)dic fileModel:(NSArray *) fileModel success:(Success)success faild:(Faild)faild;

+ (void) upLoad:(NSString *)path paramter:(NSDictionary *)dic fileModelOne:(YYNetModel *) fileModel success:(Success)success faild:(Faild)faild;

//定位

//网络监测

@end
