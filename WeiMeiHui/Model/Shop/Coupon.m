//
//  Coupon.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

+(instancetype)couponWithDict:(NSDictionary *)dic{
    
    Coupon *order = [[Coupon alloc]init];
    [order setValuesForKeysWithDictionary:dic];
//     order.nameWidth = [order.coupon_content textSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:12].lineHeight)].width;
    order.coupon_content = [NSString stringWithFormat:@"%@",order.coupon_content];
    [order calculateHegihtAndAttributedString:order.coupon_content];
    [order calculateHegihtAndAttributedStringMain:order.coupon_content];
    return order;
    
}

#pragma 计算高度
-(void)calculateHegihtAndAttributedStringMain:(NSString *)content
{
    
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing=4;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:12];
    textContainer.text = content;
    textContainer.textColor = [UIColor lightGrayColor];
//    textContainer.textAlignment = NSTextAlignmentCenter;
    
//    _textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*2];
    _textContainerMain = [textContainer createTextContainerWithTextWidth:kWidth-Space*4-60];
    _contentHeightMain = textContainer.textHeight;
    
}

-(void)calculateHegihtAndAttributedString:(NSString *)content
{
    
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing = 4;
    textContainer.lineBreakMode = kCTLineBreakByCharWrapping;
    textContainer.font = [UIFont systemFontOfSize:12];
    textContainer.text = content;
    textContainer.textColor = [UIColor lightGrayColor];
    textContainer.numberOfLines = 0;
    
    _textContainer = [textContainer createTextContainerWithTextWidth:kWidth-CELL_SIDEMARGIN*4];
//    _textContainerMain = [textContainer createTextContainerWithTextWidth:kWidth-Space*2-60];
    _contentHeight = textContainer.textHeight;
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}


@end
