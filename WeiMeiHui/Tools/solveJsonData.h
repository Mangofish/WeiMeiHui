//
//  solveJsonData.h
//  
//
//  Created by ldy on 15/12/18.
//  Copyright © 2015年 ldyD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface solveJsonData : NSDictionary
//-------------------------------------------------------------------------------------------------------------------------------------------------------
+(NSDictionary *)nullDic:(NSDictionary *)myDic;
//-------------------------------------------------------------------------------------------------------------------------------------------------------
//将NSDictionary中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr;
//-------------------------------------------------------------------------------------------------------------------------------------------------------
//将NSString类型的原路返回
//-------------------------------------------------------------------------------------------------------------------------------------------------------
+(NSString *)stringToString:(NSString *)string;
//-------------------------------------------------------------------------------------------------------------------------------------------------------
//将Null类型的项目转化成@""
//-------------------------------------------------------------------------------------------------------------------------------------------------------
+(NSString *)nullToString;
//类型识别:将所有的NSNull类型转化成@""
//-------------------------------------------------------------------------------------------------------------------------------------------------------
+(id)changeType:(id)myObj;
//-------------------------------------------------------------------------------------------------------------------------------------------------------
@end
