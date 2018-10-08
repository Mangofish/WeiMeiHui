//
//  YYNetModel.h
//  Track
//
//  Created by 于悦 on 16/7/29.
//  Copyright © 2016年 jerehedu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYNetModel : NSObject

/** 二进制数据*/
@property(nonatomic,strong) NSData * fileData;

/** 服务器文件名*/
@property(nonatomic,copy) NSString  * name;

/** 转存文件名*/
@property(nonatomic,copy) NSString * fileName;

/** mimeType*/
@property(nonatomic,copy) NSString *  mimeType;

@end
