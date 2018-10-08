//
//  MainOrderStatus.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MainOrderStatusAlready.h"

@implementation MainOrderStatusAlready

+(instancetype)mainOrderStatusWithDict:(NSDictionary *)dic{
    
    MainOrderStatusAlready *order = [[MainOrderStatusAlready alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    
    order.price = [NSString stringWithFormat:@"%@",order.price];
    if (![order.price containsString:@"元"]) {
        order.price = [NSString stringWithFormat:@"%@元",order.price];
    }
    order.graded = [NSString stringWithFormat:@"%@分",order.graded];
    order.order_num = [NSString stringWithFormat:@"订单（%@）",order.order_num];
    order.order = [NSString stringWithFormat:@"订单（%@）",order.order];
    
    if (order.author_name.length) {
        order.nameWidth = [order.author_name textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:13].lineHeight)].width;
    }else{
        order.nameWidth = [order.nickname textSizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:15].lineHeight)].width;
    }
    
    order.countWidth = [order.order_num textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:13].lineHeight)].width;
    
     [order calculateHegihtAndAttributedString:order.author_content isPrice:NO];
    
    return order;
    
}


#pragma 计算高度
-(void)calculateHegihtAndAttributedString:(NSString *)content isPrice:(BOOL)isPrice
{
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing=4;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:14];
    textContainer.text = content;
    textContainer.textColor = MJRefreshColor(102, 102, 102);
    
    if (isPrice) {
        _textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2-80];
    }else{
        _textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2];
    }
    
    
    _contentHeight = textContainer.textHeight;
    
    if (textContainer.textHeight < 10) {
        _contentHeight = 25;
    }
    
    //    if (_contentHeight > 46) {
    //        _contentHeight = 46;
    //    }
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
