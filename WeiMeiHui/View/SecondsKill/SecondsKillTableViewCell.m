//
//  SecondsKillTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "SecondsKillTableViewCell.h"
//#import "ZYLineProgressView.h"

@implementation SecondsKillTableViewCell

+(instancetype)secondsKillTableViewCell{
    
    SecondsKillTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"SecondsKillTableViewCell" owner:nil options:nil][0];
    
    cell.buyBtn.layer.cornerRadius = 4;
    cell.buyBtn.layer.masksToBounds = YES;
    ZYLineProgressView *progressView = [[ZYLineProgressView alloc] init];
    
    //    progressView.score.text =
    
//    ZYLineProgressViewConfig *config = [[ZYLineProgressViewConfig alloc]init];
    [progressView updateConfig:^(ZYLineProgressViewConfig *config) {
        config.isShowDot = NO;
        config.backLineColor = [UIColor colorWithRed:248/255.0 green:176/255.0 blue:185/255.0 alpha:1];
    }];
    
    [cell.contentView addSubview:progressView];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(cell.img.mas_right).offset(Space);
        make.top.mas_equalTo(cell.peiceLab.mas_bottom).offset(Space);
        make.height.mas_equalTo(@(15));
        make.width.mas_equalTo(@(150));
        
    }];
    
    cell.progressView = progressView;
    
    return cell;
}

+(instancetype)secondsKillTableViewCellSold{
    
    SecondsKillTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"SecondsKillTableViewCell" owner:nil options:nil][1];
    
    cell.buyBtn.layer.cornerRadius = 4;
    cell.buyBtn.layer.masksToBounds = YES;
    
    
    return cell;
}

+(instancetype)secondsKillTableViewCellRemind{
    
    SecondsKillTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"SecondsKillTableViewCell" owner:nil options:nil][2];
    
    cell.remindBtn.layer.cornerRadius = 4;
    cell.remindBtn.layer.masksToBounds = YES;
    
    
    return cell;
}

+(instancetype)secondsKillTableViewCellCancel{
    
    SecondsKillTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"SecondsKillTableViewCell" owner:nil options:nil][3];
    
    cell.remindBtn.layer.cornerRadius = 4;
    cell.remindBtn.layer.masksToBounds = YES;
    cell.remindBtn.layer.borderColor = [UIColor colorWithRed:37/255.0 green:196/255.0 blue:104/255.0 alpha:1].CGColor;
    cell.remindBtn.layer.borderWidth = 1;
    
    return cell;
}


- (void)setGoods:(SecondKillGoods *)goods{
    
    _remindBtn.tag = self.tag;
    _buyBtn.tag = self.tag;
    
    [_img sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goods.pic] placeholderImage:[UIImage imageNamed:@"test2"]];
    _nameLab.text = goods.goods_name;
    _shopLab.text = goods.shop_name;
    
    _peiceLab.text = [NSString stringWithFormat:@"¥%@",goods.sec_price];
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"¥%@",goods.org_price] attributes:attribtDic];
    
    // 赋值
    _orgPriceLab.attributedText = attribtStr;
    
    
    
    NSUInteger count = [goods.num integerValue];
    NSUInteger countlast = [goods.inventory integerValue];
    
     _progressView.progress = ((double)(count-countlast)/count);
    _progressView.progressText = [NSString stringWithFormat:@"剩余%@个",goods.inventory];
    _progressView.percentText = [NSString stringWithFormat:@"%@",goods.percent];
    _countLab.text = [NSString stringWithFormat:@"%@人已购买",goods.num];
    
}

- (IBAction)remindAction:(UIButton *)sender {
    
    [self.delegate didClickMenuIndex:sender.tag];
    
}

- (IBAction)buy:(UIButton *)sender {
    
    [self.delegate didClickBuyIndex:sender.tag];
    
}
@end
