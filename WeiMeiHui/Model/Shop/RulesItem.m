//
//  RulesItem.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "RulesItem.h"

@implementation RulesItem


+(instancetype)authorGoodsWithDict:(NSDictionary *)dic{
    
    RulesItem *order = [[RulesItem alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    [order calculateHegihtAndAttributedString:order.content];
    return order;
    
}

#pragma 计算高度
-(void)calculateHegihtAndAttributedString:(NSString *)content
{
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing = 4;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:14];
    textContainer.text = content;
    textContainer.textColor = MJRefreshColor(51, 51, 51);
    
    _textContainer = [textContainer createTextContainerWithTextWidth:kWidth-Space*2];
    
    _contentHeight = textContainer.textHeight;
   
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}


@end
