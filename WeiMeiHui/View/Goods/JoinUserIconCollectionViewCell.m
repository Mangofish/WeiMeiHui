//
//  JoinUserIconCollectionViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "JoinUserIconCollectionViewCell.h"

@implementation JoinUserIconCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self = [[NSBundle mainBundle] loadNibNamed:@"JoinUserIconCollectionViewCell" owner:self options:nil][0];
    }
    return self;
}


@end
