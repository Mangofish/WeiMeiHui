//
//  FamousGoodsTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/8/4.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "FamousGoodsTableViewCell.h"

@interface FamousGoodsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *activityLab;
@property (weak, nonatomic) IBOutlet UILabel *authornameLab;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *saleLab;


@property (weak, nonatomic) IBOutlet UILabel *redLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end


@implementation FamousGoodsTableViewCell

+ (instancetype)famousGoodsTableViewCell{
    
    FamousGoodsTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousGoodsTableViewCell" owner:nil options:nil][0];
    
//    instance.activityLab.layer.cornerRadius = 2;
//    instance.activityLab.layer.masksToBounds = YES;
//    instance.activityLab.layer.borderColor = MainColor.CGColor;
//    instance.activityLab.layer.borderWidth = 1;
    
    
    instance.nickLab.layer.cornerRadius = 5;
    instance.nickLab.layer.masksToBounds = YES;
    
    return instance;
}

+ (instancetype)famousGoodsTableViewCellSale{
    
    FamousGoodsTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousGoodsTableViewCell" owner:nil options:nil][1];
    
//    instance.activityLab.layer.cornerRadius = 2;
//    instance.activityLab.layer.masksToBounds = YES;
//    instance.activityLab.layer.borderColor = MainColor.CGColor;
//    instance.activityLab.layer.borderWidth = 1;
    
    
    instance.nickLab.layer.cornerRadius = 5;
    instance.nickLab.layer.masksToBounds = YES;
    
    instance.redView.layer.cornerRadius = 2;
    instance.redView.layer.masksToBounds = YES;
    
    return instance;
}

+ (instancetype)famousGoodsTableViewCellDetail{
    
    FamousGoodsTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousGoodsTableViewCell" owner:nil options:nil][2];
    
//    instance.activityLab.layer.cornerRadius = 2;
//    instance.activityLab.layer.masksToBounds = YES;
//    instance.activityLab.layer.borderColor = MainColor.CGColor;
//    instance.activityLab.layer.borderWidth = 1;
    
    
    instance.nickLab.layer.cornerRadius = 5;
    instance.nickLab.layer.masksToBounds = YES;
    
    instance.redView.layer.cornerRadius = 2;
    instance.redView.layer.masksToBounds = YES;
    
    return instance;
}


+ (instancetype)famousGoodsTableViewCellSearch{
    
    FamousGoodsTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousGoodsTableViewCell" owner:nil options:nil][3];
    
    
    instance.nickLab.layer.cornerRadius = 5;
    instance.nickLab.layer.masksToBounds = YES;
    
    instance.redLab.layer.cornerRadius = 2;
    instance.redLab.layer.masksToBounds = YES;
    
    return instance;
}

+ (instancetype)famousGoodsTableViewCellDetailT{
    
    FamousGoodsTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousGoodsTableViewCell" owner:nil options:nil][4];
    
//    instance.activityLab.layer.cornerRadius = 2;
//    instance.activityLab.layer.masksToBounds = YES;
//    instance.activityLab.layer.borderColor = MainColor.CGColor;
//    instance.activityLab.layer.borderWidth = 1;
    
    
    instance.nickLab.layer.cornerRadius = 5;
    instance.nickLab.layer.masksToBounds = YES;
    
    instance.redLab.layer.cornerRadius = 2;
    instance.redLab.layer.masksToBounds = YES;
    
    return instance;
}

+ (instancetype)famousGoodsTableViewCellDetailS{
    
    FamousGoodsTableViewCell *instance = [[NSBundle mainBundle] loadNibNamed:@"FamousGoodsTableViewCell" owner:nil options:nil][5];
    
    instance.statusLab.layer.cornerRadius = 2;
    instance.statusLab.layer.masksToBounds = YES;
    
    instance.redLab.layer.cornerRadius = 2;
    instance.redLab.layer.masksToBounds = YES;
    
    return instance;
}

-(void)setGoods:(AuthorGoods *)goods{
    
    [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goods.image] placeholderImage:[UIImage imageNamed:@"test"]];
    
    if (goods.pic.length) {
        [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goods.pic] placeholderImage:[UIImage imageNamed:@"test"]];
    }
    
    _tagLab.text = goods.tag_name;
    _nameLab.text = goods.goods_name;
    _priceLab.text = goods.dis_price;
    
    if (goods.activity_name.length == 0) {
        
        _activityLab.textColor = LightFontColor;
        //         _activityLab.text = [NSString stringWithFormat:@"%@",goodsSearch.org_price];
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",goods.org_price] attributes:attribtDic];
        
        // 赋值
        _activityLab.attributedText = attribtStr;
        
    }else{
        _activityLab.textColor = MainColor;
        _activityLab.layer.cornerRadius = 2;
        _activityLab.layer.masksToBounds = YES;
        _activityLab.layer.borderColor = MainColor.CGColor;
        _activityLab.layer.borderWidth = 1;
        _activityLab.text = [NSString stringWithFormat:@" %@ ",goods.activity_name];
    }
    
    
    if (goods.grade.length == 0) {
        _nickLab.hidden = YES;
    }else{
        _nickLab.hidden = NO;
    }
    
//    _activityLab.text = [NSString stringWithFormat:@" %@ ",goods.activity_name];
    _authornameLab.text = goods.nickname;
    
    _nickLab.text = [NSString stringWithFormat:@" %@ ",goods.grade];
    
    if (goods.sales.length) {
        _saleLab.text = goods.sales;
    }
    
    if (goods.sold.length) {
        _saleLab.text = goods.sold;
    }
    
   
    
}

-(void)setGoodsS:(AuthorGoods *)goodsS{
    
    
    _tagLab.text = goodsS.tag_name;
    _nameLab.text = goodsS.goods_name;
    _priceLab.text = goodsS.dis_price;

    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",goodsS.org_price] attributes:attribtDic];
    
    // 赋值
    _activityLab.attributedText = attribtStr;
    
    _saleLab.text = goodsS.sales;
    _statusLab.hidden = YES;
    if (goodsS.pay_time.length) {
        _statusLab.text = [NSString stringWithFormat:@" %@ ",goodsS.pay_time];
        _statusLab.hidden = NO;
    }
    
}

- (void)setGoodsSearch:(AuthorGoods *)goodsSearch{
    
    [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goodsSearch.pic] placeholderImage:[UIImage imageNamed:@"test"]];
    _tagLab.text = [NSString stringWithFormat:@"%@",goodsSearch.tag_name];;
    _nameLab.text = goodsSearch.goods_name;
    _priceLab.text = [NSString stringWithFormat:@"%@",goodsSearch.dis_price];
    
    if (goodsSearch.activity_name.length == 0) {
        
         _activityLab.textColor = LightFontColor;
//         _activityLab.text = [NSString stringWithFormat:@"%@",goodsSearch.org_price];
        //中划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@",goodsSearch.org_price] attributes:attribtDic];
        
        // 赋值
        _activityLab.attributedText = attribtStr;
        
    }else{
        _activityLab.textColor = MainColor;
        _activityLab.layer.cornerRadius = 2;
        _activityLab.layer.masksToBounds = YES;
        _activityLab.layer.borderColor = MainColor.CGColor;
        _activityLab.layer.borderWidth = 1;
         _activityLab.text = [NSString stringWithFormat:@" %@ ",goodsSearch.activity_name];
    }
    
    if (goodsSearch.grade_name.length == 0) {
        _nickLab.hidden = YES;
    }else{
        _nickLab.hidden = NO;
    }

    _authornameLab.text = goodsSearch.nickname;
    
    _nickLab.text = [NSString stringWithFormat:@" %@ ",goodsSearch.grade_name];
    
    
    if (goodsSearch.sale_count.length) {
        _saleLab.text = [NSString stringWithFormat:@"%@",goodsSearch.sale_count];
    }
    

}
@end
