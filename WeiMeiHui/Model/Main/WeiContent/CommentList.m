//
//  CommentList.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/2/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CommentList.h"

@implementation CommentList
+(instancetype)commentListWithDict:(NSDictionary *)dic{
    
    CommentList *order = [[CommentList alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    order.nameWidth = [order.nickname textSizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:16].lineHeight)].width;
    
    order.createTimeWidth = [order.create_time textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:14].lineHeight)].width;
    
    
    [order calculateHegihtAndAttributedString:order.content];
    
    return order;
    
}

#pragma 计算高度
-(void)calculateHegihtAndAttributedString:(NSString *)content
{
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing=4;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:14];
    textContainer.text = content;
    textContainer.textColor = MJRefreshColor(102, 102, 102);
    
    _textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2];
    _contentHeight = textContainer.textHeight;
    
//    if (_contentHeight > 46) {
//         _contentHeight = 46;
//    }
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
