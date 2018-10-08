//
//  NSURL+ImageUrl.m
//  WMH_5.0
//
//  Created by Mac on 17/3/17.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "NSURL+ImageUrl.h"

@implementation NSURL (ImageUrl)

+ (instancetype)urlWithNoBlankDataString:(NSString *)url{
    
    NSString *noBlankString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *instance = [NSURL URLWithString:noBlankString];
    return instance;
}

@end
