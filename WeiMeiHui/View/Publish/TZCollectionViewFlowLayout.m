//
//  TZCollectionViewFlowLayout.m
//  WeiMeiHui
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "TZCollectionViewFlowLayout.h"

@implementation TZCollectionViewFlowLayout

/// 准备布局
- (void)prepareLayout {
    [super prepareLayout];
    //设置item尺寸
    CGFloat itemW = (self.collectionView.frame.size.width - 20-3*5)/ 4;
    self.itemSize = CGSizeMake(itemW, itemW);
    
    //设置最小间距
    self.minimumLineSpacing = 5;
    self.minimumInteritemSpacing = 5;
    
}

@end
