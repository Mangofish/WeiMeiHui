//
//  OrderComment.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "OrderComment.h"

@implementation OrderComment

+(instancetype)orderCommentWithDict:(NSDictionary *)dic{
    
    OrderComment *order = [[OrderComment alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    [order calculateHegihtAndAttributedString:order.eva_content];
    
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
