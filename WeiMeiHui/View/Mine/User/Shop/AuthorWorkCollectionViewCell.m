//
//  AuthorWorkCollectionViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorWorkCollectionViewCell.h"

@implementation AuthorWorkCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self = [[NSBundle mainBundle] loadNibNamed:@"AuthorWorkCollectionViewCell" owner:self options:nil][0];
    }
    return self;
}


@end
