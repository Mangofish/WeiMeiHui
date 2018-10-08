//
//  AuthorPriceRangeTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorPriceRangeTableViewCell.h"

@implementation AuthorPriceRangeTableViewCell

+(instancetype)authorPriceRangeTableViewCell{
    
    AuthorPriceRangeTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AuthorPriceRangeTableViewCell" owner:self options:nil][0];
    
    
    
    return cell;
    
}


@end
