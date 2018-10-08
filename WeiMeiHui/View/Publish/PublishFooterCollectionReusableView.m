//
//  PublishFooterCollectionReusableView.m
//  WeiMeiHui
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "PublishFooterCollectionReusableView.h"

@implementation PublishFooterCollectionReusableView



- (IBAction)chooseShop:(UIButton *)sender {
    [self.delegate chooseShopAction:sender];
}

- (IBAction)chooseRange:(UIButton *)sender {
     [self.delegate chooseRangeAction:sender];
}

- (IBAction)chooseWeixin:(UIButton *)sender {
    [self.delegate chooseShareAction:sender];
}

- (IBAction)chooseWeibo:(UIButton *)sender {
    [self.delegate chooseShareAction:sender];
}

- (IBAction)chooseKongjian:(UIButton *)sender {
    [self.delegate chooseShareAction:sender];
}


@end
