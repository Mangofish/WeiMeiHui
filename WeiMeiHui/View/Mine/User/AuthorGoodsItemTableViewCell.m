//
//  AuthorGoodsItemTableViewCell.m
//  WeiMeiHui
//
//  Created by 悦悦 on 2018/5/6.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "AuthorGoodsItemTableViewCell.h"
@interface AuthorGoodsItemTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *disPrice;
@property (weak, nonatomic) IBOutlet UILabel *oriPrice;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *activityLab;
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;


@end
@implementation AuthorGoodsItemTableViewCell

+(instancetype)authorGoodsItemTableViewCell{
    AuthorGoodsItemTableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"AuthorGoodsItemTableViewCell" owner:nil options:nil][0];
    cell.activityLab.layer.cornerRadius = 5;
    cell.activityLab.layer.masksToBounds = YES;
    cell.payBtn.layer.cornerRadius = 5;
    cell.payBtn.layer.masksToBounds = YES;
    
    return cell;
}

- (IBAction)payAction:(UIButton *)sender {
    [self.delegate payAuthor:sender.tag];
}

- (void)setGoods:(AuthorGoods *)goods{
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: goods.org_price attributes:attribtDic];
    
    // 赋值
    _oriPrice.attributedText = attribtStr;
    
    _disPrice.text = goods.dis_price;
    _titleLab.text = [NSString stringWithFormat:@"%@%@",goods.tag_name,goods.goods_name];
    _countLab.text = goods.sales;
    
    if (goods.activity_name.length) {
        _activityLab.text = [NSString stringWithFormat:@" %@ ",goods.activity_name];
    }else{
        _activityLab.hidden = YES;
    }
    
    
    
    //    是否拼团商品
    if ([goods.is_group integerValue] == 1) {
        
        _activityLab.layer.borderWidth = 1;
        _activityLab.layer.borderColor = MainColor.CGColor;
        _activityLab.backgroundColor = [UIColor whiteColor];
        _activityLab.textColor = MainColor;
        
    }else{
        
        _activityLab.backgroundColor = MainColor;
        _activityLab.textColor = [UIColor whiteColor];
    }
    
}
@end
