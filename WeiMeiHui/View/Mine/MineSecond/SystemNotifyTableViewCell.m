//
//  SystemNotifyTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SystemNotifyTableViewCell.h"



@implementation SystemNotifyTableViewCell

+(instancetype)systemNotifyTableViewCell{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SystemNotifyTableViewCell" owner:self options:nil][0];
    
}

@end
