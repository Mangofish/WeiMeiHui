//
//  ALLAuthorsTableViewCell.m
//  WeiMeiHui
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ALLAuthorsTableViewCell.h"
#import "UIButton+WebCache.h"
#import "UIButton+ImageTitleSpacing.h"
#import "XHStarRateView.h"

@interface ALLAuthorsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *gradeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderCount;
@property (weak, nonatomic) IBOutlet UILabel *appointLab;

@property (weak, nonatomic) IBOutlet UILabel *count;

@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (strong, nonatomic)   XHStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;


//cell2
@property (weak, nonatomic) IBOutlet UILabel *saleCount;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *redPrice;
@property (weak, nonatomic) IBOutlet UILabel *grayPrice;

@end

@implementation ALLAuthorsTableViewCell

+ (instancetype)allAuthorsTableViewCell{
    
    
    
    ALLAuthorsTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ALLAuthorsTableViewCell" owner:nil options:nil][0];
    cell.frame = CGRectMake(0, 0, kWidth, 88);
    
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(86, 12+25, 85, 12)];
    [cell.contentView addSubview:starRateView];
    cell.starRateView = starRateView;
    cell.starRateView.rateStyle = HalfStar;
    cell.starRateView.userInteractionEnabled = NO;
    
    return cell;
}

+ (instancetype)allAuthorsTableViewCellSecond{
    
    ALLAuthorsTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ALLAuthorsTableViewCell" owner:nil options:nil][1];
    cell.frame = CGRectMake(0, 0, kWidth, 49);
    return cell;
}

- (void)setAuthorKill:(ShopAuthor *)authorKill{
    
    _author = authorKill;
    
    _name.text = authorKill.author_name;
    
    if (authorKill.grade_name.length) {
        _gradeLab.text = [NSString stringWithFormat:@" %@ ",authorKill.grade_name];
    
    }else{
        _gradeLab.hidden = YES;
    }
    
    _gradeLab.layer.cornerRadius = 5;
    _gradeLab.layer.masksToBounds = YES;
    _shopName.text = authorKill.shop_name;
    _addressLab.text = authorKill.region_name;
    _starRateView.currentScore = [authorKill.average_score doubleValue];
    _scoreLab.text = [NSString stringWithFormat:@"%@",authorKill.average_score];
    _orderCount.text = [NSString stringWithFormat:@"%@",authorKill.order_num];
    self.appointLab.hidden= YES;
   
    
    [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:authorKill.image] placeholderImage:[UIImage imageNamed:@"test2"]];
    _distanceBtn.frame = CGRectMake(kWidth-Space- _author.distanceWidth-20, CGRectGetMaxY(_count.frame), _author.distanceWidth+20, 20);
    _distanceBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_distanceBtn setTitle:authorKill.distance forState:UIControlStateNormal];
    [_distanceBtn setImage:[UIImage imageNamed:@"定位2"] forState:UIControlStateNormal];
    [_distanceBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    
    _count.text = [NSString stringWithFormat:@"粉丝数：%@",authorKill.fans_count];
    _count.hidden = YES;
    _addressLab.hidden = YES;
    _distanceBtn.hidden = YES;
    
    
}


- (void)setAuthorChoose:(ShopAuthor *)authorChoose{
    
    _name.text = authorChoose.nickname;
    _gradeLab.text = [NSString stringWithFormat:@" %@ ",authorChoose.grade_name];
    
    _gradeLab.layer.cornerRadius = 8;
    _gradeLab.layer.masksToBounds = YES;
    
    _shopName.text = authorChoose.shop_name;
    _addressLab.hidden = YES;
    _starRateView.currentScore = [authorChoose.score_show doubleValue];
    _scoreLab.text = [NSString stringWithFormat:@"%@",authorChoose.score];
    _orderCount.text = [NSString stringWithFormat:@"%@",authorChoose.order_num];
    self.appointLab.hidden= YES;
    
    
    [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:authorChoose.image] placeholderImage:[UIImage imageNamed:@"test2"]];
    
    _count.hidden = YES;
    _addressLab.hidden = YES;
    _distanceBtn.hidden = YES;

}


- (void)setAuthor:(ShopAuthor *)author{
    _author = author;

    if (author.author_name.length) {
        _name.text = author.author_name;
    }else{
        _name.text = author.nickname;
    }
    
    if (author.grade_name.length) {
        _gradeLab.text = [NSString stringWithFormat:@" %@ ",author.grade_name];;
    }else if(author.grade.length){
        _gradeLab.text = [NSString stringWithFormat:@" %@ ",author.grade];;
    }else{
        _gradeLab.hidden = YES;
    }
    
    _gradeLab.layer.cornerRadius = 8;
    _gradeLab.layer.masksToBounds = YES;
    _shopName.text = author.shop_name;
    _addressLab.text = author.region_name;
    _starRateView.currentScore = [author.average_score doubleValue];
    
  
    
    _scoreLab.text = [NSString stringWithFormat:@"%@分",author.average_score];
    _orderCount.text = [NSString stringWithFormat:@"(%@单)",author.order_num];;
    
    switch ([author.is_recent integerValue]) {
        case 0:
            self.appointLab.hidden= YES;
            break;
        case 1:
        {
            self.appointLab.hidden= NO;
            self.appointLab.text = author.recent_name;
        }
            break;
        case 2:
            self.appointLab.hidden= YES;
            break;
        default:
            break;
    }
    
    [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:author.image] placeholderImage:[UIImage imageNamed:@"test2"]];
    _distanceBtn.frame = CGRectMake(kWidth-Space- _author.distanceWidth-20, CGRectGetMaxY(_count.frame), _author.distanceWidth+20, 20);
    _distanceBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_distanceBtn setTitle:author.distance forState:UIControlStateNormal];
    [_distanceBtn setImage:[UIImage imageNamed:@"定位2"] forState:UIControlStateNormal];
    [_distanceBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    _count.text = [NSString stringWithFormat:@"粉丝数：%@",author.fans_num];
    
    if (author.fans_count.length) {
          _count.text = [NSString stringWithFormat:@"粉丝数：%@",author.fans_count];
    }
    
}


-(void)setGoods:(AuthorGoods *)goods{
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString: goods.org_price attributes:attribtDic];
    
    // 赋值
    _grayPrice.attributedText = attribtStr;
    
    _redPrice.text = goods.dis_price;
    
    
    
    _titleLab.text = [NSString stringWithFormat:@"%@%@",goods.tag_name,goods.goods_name];
    _saleCount.text = goods.sales;
    
    if (goods.activity_name.length) {
        _tagLab.text = [NSString stringWithFormat:@" %@ ",goods.activity_name];
    }else{
        
        _tagLab.hidden = YES;
        
    }

     _tagLab.layer.cornerRadius = 2;
    _tagLab.layer.masksToBounds = YES;
//    是否拼团商品
    if ([goods.is_group integerValue] == 1) {
        
        _tagLab.layer.borderWidth = 1;
        _tagLab.layer.borderColor = MainColor.CGColor;
        _tagLab.backgroundColor = [UIColor whiteColor];
        _tagLab.textColor = MainColor;
        
    }else{
        
        _tagLab.backgroundColor = MainColor;
        _tagLab.textColor = [UIColor whiteColor];
    }
    
}

- (void)setGoodsDetailOne:(GoodsDetail *)goodsDetailOne{
    
    _name.text = goodsDetailOne.nickname;
    _gradeLab.text = [NSString stringWithFormat:@" %@ ",goodsDetailOne.grade];;
    _gradeLab.layer.cornerRadius = 8;
    _gradeLab.layer.masksToBounds = YES;
    _shopName.text = goodsDetailOne.shop_name;
    _addressLab.text = goodsDetailOne.region_name;
    _starRateView.currentScore = [goodsDetailOne.average_score doubleValue];
    
    _scoreLab.text = [NSString stringWithFormat:@"%@分",goodsDetailOne.average_score];
    _orderCount.text = [NSString stringWithFormat:@"(%@单)",goodsDetailOne.order_num];;
    
//    _scoreLab.text = goodsDetailOne.average_score;
//    _orderCount.text = goodsDetailOne.order_num;
    _appointLab.hidden = YES;
    
    
    [_iconImg sd_setImageWithURL:[NSURL urlWithNoBlankDataString:goodsDetailOne.image] placeholderImage:[UIImage imageNamed:@"test2"]];
//    _distanceBtn.frame = CGRectMake(kWidth-Space- goodsDetailOne.distanceWidth-20, CGRectGetMaxY(_count.frame), goodsDetailOne.distanceWidth+20, 20);
    _distanceBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_distanceBtn setTitle:goodsDetailOne.distance forState:UIControlStateNormal];
    [_distanceBtn setImage:[UIImage imageNamed:@"定位2"] forState:UIControlStateNormal];
    [_distanceBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    _count.text = [NSString stringWithFormat:@"粉丝数：%@",goodsDetailOne.fans_num];
    
    
}



@end
