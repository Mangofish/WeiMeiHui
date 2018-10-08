//
//  ShopAuthorsCollectionViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ShopAuthorsCollectionViewCell.h"

@implementation ShopAuthorsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self = [[NSBundle mainBundle] loadNibNamed:@"ShopAuthorsCollectionViewCell" owner:self options:nil][0];
        
    }
    return self;
}

@end
