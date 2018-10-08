//
//  YYNet.m
//  ch12网络登录注册
//
//  Created by 于悦 on 16/7/29.
//  Copyright © 2016年 jereh. All rights reserved.
//

#import "YYNet.h"

@implementation YYNet

#pragma mark - GET请求
+ (void) GET:(NSString *) path paramters:(NSDictionary *)dic success:(Success) success faild:(Faild)faild{
    
    //    拼接路径
    NSMutableString *paramters = [NSMutableString string];
    for (NSString *key in dic) {
        [paramters appendFormat:@"%@=%@&",key,dic[key]];
    }
    
    NSString *finalPath = @"";
    if ([path containsString:@"?"]) {
        finalPath = [NSString stringWithFormat:@"%@&%@",path,paramters];
    }else{
        finalPath = [NSString stringWithFormat:@"%@?%@",path,paramters];
    }
    
    if (paramters == nil) {
        finalPath = path;
    }
    
    
    
    [self GETByAFN:path paramters:dic success:^(id responseObject) {
        success(responseObject);
    } faild:^(id responseObject) {
        faild(responseObject);
    }];
}

+ (void)GET:(NSString *)path paramter:(NSDictionary *)dic success:(Success)success faild:(Faild)faild{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:path parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faild(error);
        
    }];

}

+ (void)GETBySession:(NSString *) path paramters:(NSDictionary *)dic success:(Success) success faild:(Faild)faild{
//    得到Session
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (error) {
                faild(error);
            }else{
                success(data);
            }
        });
    }];
    [task resume];
}

+ (void)GETByAFN:(NSString *)path paramters:(NSDictionary *)dic success:(Success)success faild:(Faild)faild{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager GET:path parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faild(error);
        
    }];
}

#pragma mark - POST请求
+ (void) POST:(NSString *)path paramters:(NSDictionary *)dic success:(Success)success faild:(Faild)faild{
//   YYHud* hud = [[YYHud alloc]init];
//    [hud showInView:[UIApplication sharedApplication].keyWindow];
    [self POSTByAFN:path paramters:dic success:^(id responseObject) {
        
        success(responseObject);

        
    } faild:^(id responseObject) {
        
        faild(responseObject);
//        NSDictionary *dic = [solveJsonData changeType:responseObject];
//        FFToast *toast = [[FFToast alloc]initToastWithTitle:nil message:dic[@"info"] iconImage:[UIImage imageNamed:@"error"]];
//        toast.toastType = FFToastTypeSuccess;
//        toast.toastPosition = FFToastPositionCentreWithFillet;
//        [toast show];
       
    }];
}

+ (void) POSTByAFN:(NSString *) path paramters:(NSDictionary *)dic success:(Success) success faild:(Faild)faild{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:path parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        faild(error);
    }];
    
}

#pragma mark - 上传
+ (void) upLoad:(NSString *)path paramter:(NSDictionary *)dic fileModel:(NSArray *) fileModel success:(Success)success faild:(Faild)faild{
    
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    YYHud* hud = [[YYHud alloc]init];
    [hud showInView:[UIApplication sharedApplication].keyWindow];
    
    [manager POST:path parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (YYNetModel *model in fileModel) {
          [formData appendPartWithFileData:model.fileData name:model.name fileName:model.fileName mimeType:model.mimeType];
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        [hud dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild(error);
        [hud dismiss];
    }];
    
    
}

+ (void) upLoad:(NSString *)path paramter:(NSDictionary *)dic fileModelOne:(YYNetModel *) fileModel success:(Success)success faild:(Faild)faild{
    
    AFHTTPSessionManager * manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:path parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileModel.fileData name:fileModel.name fileName:fileModel.fileName mimeType:fileModel.mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        faild(error);
    }];
}

@end
