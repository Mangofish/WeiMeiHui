//
//  LocateAuthorityTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "LocateAuthorityTableViewCell.h"

@implementation LocateAuthorityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"LocateAuthorityTableViewCell" owner:self options:nil][0];
        self.openBtn.layer.cornerRadius = 4;
        self.openBtn.layer.masksToBounds = YES;
    }
    
    return self;
}

- (IBAction)open:(UIButton *)sender {
    [self.delegate openAction];
}

@end
