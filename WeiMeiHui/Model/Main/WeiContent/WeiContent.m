//
//  WeiContent.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "WeiContent.h"
#import "WeiContentImageView.h"
@implementation WeiContent

+(instancetype)contentListWithDict:(NSDictionary *)dic{
    
    WeiContent *order = [[WeiContent alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    
    order.ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
    
    order.nameWidth = [order.nickname textSizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:16].lineHeight)].width;
    
    order.nickWidth = [order.grade_name textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:13].lineHeight)].width;
    
    order.distance = [NSString stringWithFormat:@"%@",order.distance];
    order.distanceWidth = [order.distance textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:13].lineHeight)].width;
    order.createTimeWidth = [order.create_time textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:14].lineHeight)].width;
    
    order.views = [NSString stringWithFormat:@"%@浏览",order.views];
    order.viewsWidth = [order.views textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:13].lineHeight)].width;
    
    if (order.shop_address.length) {
        order.shop_address = [NSString stringWithFormat:@"    %@    ",order.shop_address];
    }
    order.addressWidth = [order.shop_address textSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:12].lineHeight)].width;
    
     order.commentWidth = [order.comments textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:13].lineHeight)].width + 28;
    
     order.praiseWidth = [order.praises textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:13].lineHeight)].width + 20;
    
    if ([order.price doubleValue]   != 0 ) {
        order.price = [NSString stringWithFormat:@"¥%@",order.price];
         [order calculateHegihtAndAttributedString:order.content isPrice:YES];
    }else{
        order.price = @"";
        [order calculateHegihtAndAttributedString:order.content isPrice:NO];
    }
    
    
   
    [order calculateContentImageViewHegiht:order.pic];
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

#pragma 暂时这样子处理图片
-(void)calculateContentImageViewHegiht:(NSArray *)pic
{
    self.contengImageHeight=[WeiContentImageView getContentImageViewHeight:pic];
}

@end
