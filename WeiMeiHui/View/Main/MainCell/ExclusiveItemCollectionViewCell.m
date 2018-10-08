//
//  ExclusiveItemCollectionViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ExclusiveItemCollectionViewCell.h"

@implementation ExclusiveItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self = [[NSBundle mainBundle] loadNibNamed:@"ExclusiveItemCollectionViewCell" owner:self options:nil][0];
//        self.img.layer.cornerRadius = 20;
//        self.img.layer.masksToBounds = YES;
        
    }
    return self;
}

@end
