//
//  CouponDown.m
//  WeiMeiHui
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "CouponDown.h"

@implementation CouponDown

+(instancetype)couponWithDict:(NSDictionary *)dic{
    
    CouponDown *order = [[CouponDown alloc]init];
    [order setValuesForKeysWithDictionary:dic];
    //     order.nameWidth = [order.coupon_content textSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kWidth, [UIFont systemFontOfSize:12].lineHeight)].width;
    order.coupon_content = [NSString stringWithFormat:@"%@",order.coupon_content];
    
    order.textContainer = [order calculateHegihtAndAttributedStringMain:order.coupon_content andFontSize:10 color:[UIColor lightGrayColor] andWidth:kWidth-Space*4 andtextAlign:NSTextAlignmentLeft];
    
    order.detailTextContainer = [order calculateHegihtAndAttributedStringMain:order.name andFontSize:10 color:[UIColor lightGrayColor] andWidth:(kWidth-Space*4)/3-Space andtextAlign:NSTextAlignmentRight];
    
    if ([order.status integerValue] == 1) {
        
        order.moneyTextContainer = [order calculateHegihtAndAttributedStringMain:order.par_value andFontSize:14 color:MainColor andWidth:(kWidth-Space*3)/3-Space andtextAlign:NSTextAlignmentRight];
        
        order.titleTextContainer = [order calculateHegihtAndAttributedStringMain:order.coupon_dis andFontSize:14 color:FontColor andWidth:kWidth - (kWidth-Space*2)/3 - Space*3 andtextAlign:NSTextAlignmentLeft];
        
        order.timeTextContainer =[order calculateHegihtAndAttributedStringMain:order.end_time andFontSize:10 color:MainColor andWidth:kWidth - (kWidth-Space*2)/3 - Space*3-72 andtextAlign:NSTextAlignmentLeft];
        
    }else{
        order.moneyTextContainer = [order calculateHegihtAndAttributedStringMain:order.par_value andFontSize:14 color:LightFontColor andWidth:(kWidth-Space*3)/3-Space andtextAlign:NSTextAlignmentRight];
        
        order.titleTextContainer = [order calculateHegihtAndAttributedStringMain:order.coupon_dis andFontSize:14 color:LightFontColor andWidth:kWidth - (kWidth-Space*2)/3 - Space*3 andtextAlign:NSTextAlignmentLeft];
        
        order.timeTextContainer =[order calculateHegihtAndAttributedStringMain:order.end_time andFontSize:10 color:LightFontColor andWidth:kWidth - (kWidth-Space*2)/3 - Space*3-72 andtextAlign:NSTextAlignmentLeft];
    }
    
    
    
    return order;
    
}

#pragma 计算高度
-(TYTextContainer *)calculateHegihtAndAttributedStringMain:(NSString *)content andFontSize:(NSUInteger)size
                                                     color:(UIColor *)color andWidth:(CGFloat )width andtextAlign:(NSUInteger )textAli{
    
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing=4;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:size];
    textContainer.text = content;
    textContainer.textColor = color;
    textContainer.textAlignment = textAli;
    
   return  [textContainer createTextContainerWithTextWidth:width];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

@end
