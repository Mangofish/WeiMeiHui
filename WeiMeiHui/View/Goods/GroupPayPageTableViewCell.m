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

+ (instancetype)groupPayPageTableViewCellSix{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][5];
    
    return cell;
}

+ (instancetype)groupPayPageTableViewCellSeven{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][6];
    cell.bgView7.layer.cornerRadius = 4;
    cell.bgView7.layer.masksToBounds = YES;
    return cell;
}

+ (instancetype)groupPayPageTableViewCellEight{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][7];
    cell.bgView7.layer.cornerRadius = 4;
    cell.bgView7.layer.masksToBounds = YES;
    return cell;
}

+ (instancetype)groupPayPageTableViewCellNight{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][8];
    cell.bgView7.layer.cornerRadius = 4;
    cell.bgView7.layer.masksToBounds = YES;
    return cell;
}

+ (instancetype)groupPayPageTableViewCellTen{
    
    GroupPayPageTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"GroupPayPageTableViewCell" owner:nil options:nil][9];
    cell.explainLab = [[TYAttributedLabel alloc]init];
    [cell.contentView addSubview:cell.explainLab];
    
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

#pragma 计算高度
-(TYTextContainer *)calculateHegihtAndAttributedStringMain:(NSString *)content andFontSize:(NSUInteger)size
                                                     color:(UIColor *)color andWidth:(CGFloat )width andtextAlign:(NSUInteger )textAli{
    
    TYTextContainer * textContainer=[[TYTextContainer alloc]init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing = 4;
    textContainer.lineBreakMode = kCTLineBreakByWordWrapping;
    textContainer.font = [UIFont systemFontOfSize:size];
    textContainer.text = content;
    textContainer.textColor = color;
    textContainer.textAlignment = textAli;
    
    return  [textContainer createTextContainerWithTextWidth:width];
    
}

- (IBAction)increaseAction:(id)sender {
    
    [self.delegate plus];
}


- (IBAction)decreseAction:(UIButton *)sender {
    [self.delegate decrese];
}

@end
