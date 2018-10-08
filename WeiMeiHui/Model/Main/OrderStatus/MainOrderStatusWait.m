//
//  MainOrderStatusWait.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MainOrderStatusWait.h"

@implementation MainOrderStatusWait

+(instancetype)mainOrderStatusWithDict:(NSDictionary *)dic{
    
    MainOrderStatusWait *order = [[MainOrderStatusWait alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    order.price = [NSString stringWithFormat:@"%@",order.price];
    order.area = [NSString stringWithFormat:@"服务区域：%@",order.area];
    [order calculateHegihtAndAttributedString:order.content];
    
    return order;
    
}

#pragma 计算高度
-(void)calculateHegihtAndAttributedString:(NSString *)content
{
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing=6;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:14];
    textContainer.text = content;
    textContainer.textColor = MJRefreshColor(51, 51, 51);
    
    _textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2];
    
    _contentHeight = textContainer.textHeight;
    
    if (textContainer.textHeight > 46) {
        _contentHeight = 46;
    }
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
