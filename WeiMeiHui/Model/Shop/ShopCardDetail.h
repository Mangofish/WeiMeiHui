//
//  ShopCardDetail.h
//  WeiMeiHui
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCardDetail : NSObject

@property (nonatomic, copy) NSString *use_note;
@property (nonatomic, copy) NSString *card_summary;

@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *qrcode;

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *status;

+(instancetype)shopCardDetailWithDict:(NSDictionary *)dic;

@end
