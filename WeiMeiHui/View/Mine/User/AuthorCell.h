//
//  AuthorCell.h
//  WeiMeiHui
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorCell : UIView

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *nickImg;

@property (weak, nonatomic) IBOutlet UIButton *vip;
@property (weak, nonatomic) IBOutlet UILabel *name;

+(instancetype)authorCell;

@end
