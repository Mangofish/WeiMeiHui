//
//  DyPayByAliTool.h
//  WMHUser
//
//  Created by 罗大勇 on 16/8/27.
//  Copyright © 2016年 罗大勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DyPayByAliTool : NSObject


+ (void)payByAliWithSubjects:(NSString *)subjects
                        body:(NSString *)body
                       price:(double)price
                     orderId:(NSString *)orderId
                     partner:(NSString *)partner
                      seller:(NSString *)seller url:(NSString *)url
                  privateKey:(NSString *)privateKey
                     success:(void(^)(NSDictionary *info))success;

@end
