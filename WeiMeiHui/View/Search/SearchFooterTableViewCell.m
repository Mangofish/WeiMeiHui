//
//  SearchFooterTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SearchFooterTableViewCell.h"

@implementation SearchFooterTableViewCell

+(instancetype)searchFooterTableViewCell{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SearchFooterTableViewCell" owner:nil options:nil][0];
    
}

+(instancetype)searchFooterTableViewCellFooter{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SearchFooterTableViewCell" owner:nil options:nil][1];
    
}

- (IBAction)clickAction:(UIButton *)sender {
    
    [self.delegate lookMore:sender.tag];
    
}

@end
