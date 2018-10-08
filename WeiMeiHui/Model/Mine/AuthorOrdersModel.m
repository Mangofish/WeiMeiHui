//
//  AuthorOrdersModel.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorOrdersModel.h"

@implementation AuthorOrdersModel

+(instancetype)orderInfoWithDict:(NSDictionary *)dic{
    
    AuthorOrdersModel *order = [[AuthorOrdersModel alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    order.order_number = [NSString stringWithFormat:@"订单编号：%@",order.order_number];
    
    if (order.price.length) {
        order.price = [NSString stringWithFormat:@"¥%@",order.price];
    }else{
        order.price = [NSString stringWithFormat:@"%@元-%@元",order.min_price,order.max_price];
    }
    
    
    if (!order.dumps_name.length) {
        order.dumps_name = [NSString stringWithFormat:@"服务区域：%@",order.area];
    }else{
        order.dumps_name = [NSString stringWithFormat:@"服务区域：%@",order.dumps_name];
    }
    
    if (!order.service_name.length) {
        order.service_name = [NSString stringWithFormat:@"%@",order.service_type];
    }else{
        order.service_name = [NSString stringWithFormat:@"%@",order.service_name];
    }
    
    
   TYTextContainer *temp = [order calculateHegihtAndAttributedString:order.content];
    order.textContainer = [temp createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2];
    order.contentHeight = order.textContainer.textHeight;
    if (order.textContainer.textHeight > 46) {
        order.contentHeight = 46;
    }
    
    if (order.author_content) {
        TYTextContainer *temp = [order calculateHegihtAndAttributedString:order.author_content];
        order.authorTextContainer = [temp createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2];
        order.authorContentHeight = order.authorTextContainer.textHeight;
        
        if (order.authorTextContainer.textHeight > 46) {
            order.contentHeight = 46;
        }
        
    }
    
    return order;
    
}

#pragma 计算高度
-(TYTextContainer *)calculateHegihtAndAttributedString:(NSString *)content
{
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing=6;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:14];
    textContainer.text = content;
    textContainer.textColor = MJRefreshColor(51, 51, 51);
    
    return textContainer;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
