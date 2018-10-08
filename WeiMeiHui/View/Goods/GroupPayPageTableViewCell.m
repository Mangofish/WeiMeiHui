//
//  GroupPayPageTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "GroupPayPageTableViewCell.h"

@implementation GroupPayPageTableViewCell

+ (instancetype)groupPayPageTableViewCellOne{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][0];
    
    return cell;
}


+ (instancetype)groupPayPageTableViewCellTwo{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][1];
    cell.leftBtn.layer.borderColor = MainColor.CGColor;
    cell.leftBtn.layer.cornerRadius =  3;
    cell.rightBtn.layer.cornerRadius = 3;
    cell.rightBtn.layer.borderColor = LightFontColor.CGColor;
    cell.leftBtn.layer.borderWidth = 1;
    cell.rightBtn.layer.borderWidth = 1;
    return cell;
}

+ (instancetype)groupPayPageTableViewCellThree{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][2];
    
    return cell;
}



+ (instancetype)groupPayPageTableViewCellFour{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][3];
    
    return cell;
}

+ (instancetype)groupPayPageTableViewCellFive{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][4];
    
    return cell;
}


- (IBAction)leftAction:(UIButton *)sender {
    
        
    if (sender.tag == 1) {
        
       
        self.rightBtn.titleLabel.textColor = LightFontColor;
        self.rightBtn.layer.borderColor = LightFontColor.CGColor;
    
        self.leftBtn.titleLabel.textColor = MainColor;
        self.leftBtn.layer.borderColor = MainColor.CGColor;
        
    }else{
        
        
        self.leftBtn.titleLabel.textColor = LightFontColor;
        self.leftBtn.layer.borderColor = LightFontColor.CGColor;
        
        self.rightBtn.titleLabel.textColor = MainColor;
        self.rightBtn.layer.borderColor = MainColor.CGColor;
    }
    
    [self.delegate didSelectedItemAtIndex:sender.tag];
    
}

- (IBAction)increaseAction:(id)sender {
    
    [self.delegate plus];
}


- (IBAction)decreseAction:(UIButton *)sender {
    [self.delegate decrese];
}

@end
