//
//  AuthorCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorCell.h"

@implementation AuthorCell

+(instancetype)authorCell{
    
    AuthorCell *instance = [[NSBundle mainBundle] loadNibNamed:@"AuthorCell" owner:nil options:nil][0];
    instance.nickImg.layer.cornerRadius = 4;
    instance.nickImg.layer.masksToBounds = YES;
    return instance;
    
}


@end
