//
//  UILabel+Utils.h
//  WeiMeiHui
//
//  Created by apple on 2017/9/26.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

@end
